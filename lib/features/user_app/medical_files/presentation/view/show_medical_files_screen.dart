import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/Api_services/urls.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view/add_medical_file_screen.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view_model/medical_files_cubit.dart';

class ShowMedicalFilesScreen extends StatelessWidget {
  static const String routeName = '/medical_files';

  const ShowMedicalFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalFilesCubit>(
      create: (BuildContext context) =>
          MedicalFilesCubit(getit.get<MedicalFilesRepo>())..loadMedicalFiles(),
      child: const _ShowMedicalFilesView(),
    );
  }
}

class _ShowMedicalFilesView extends StatelessWidget {
  const _ShowMedicalFilesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(title: 'medical_files'.tr(context)),
      ),

      body: BlocBuilder<MedicalFilesCubit, MedicalFilesState>(
        builder: (BuildContext context, MedicalFilesState state) {
          if (state.status == MedicalFilesStatus.loading &&
              state.files.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MedicalFilesStatus.failure) {
            return CustomErrorWidget(
              errorMessage: state.errorMessage,
              textColor: AppColors.blackColor,
              onRetry: () =>
                  context.read<MedicalFilesCubit>().loadMedicalFiles(),
            );
          }

          final int radiologyCount = state.files
              .where(
                (MedicalFile file) => file.type == MedicalFileType.radiology,
              )
              .length;
          final int labCount = state.files
              .where((MedicalFile file) => file.type == MedicalFileType.lab)
              .length;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<MedicalFilesCubit>().loadMedicalFiles(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: <Widget>[
                _SummaryCard(
                  totalFiles: state.files.length,
                  radiologyCount: radiologyCount,
                  labCount: labCount,
                  onAddPressed: () => _openAddScreen(context),
                ),
                const SizedBox(height: 18),
                _FilterCard(
                  child: _FilterChips(
                    selectedFilter: state.filter,
                    onChanged: context.read<MedicalFilesCubit>().changeFilter,
                  ),
                ),
                const SizedBox(height: 18),
                if (state.filteredFiles.isEmpty)
                  _EmptyMedicalFilesState(
                    onAddPressed: () => _openAddScreen(context),
                  )
                else
                  ...state.filteredFiles.map(
                    (MedicalFile file) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MedicalFileCard(
                        file: file,
                        onShow: () => _showMedicalFile(context, file),
                        onDownload: () => _downloadMedicalFile(context, file),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAddScreen(BuildContext context) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider.value(
          value: context.read<MedicalFilesCubit>(),
          child: const AddMedicalFileScreen(),
        ),
      ),
    );
  }

  Future<void> _showMedicalFile(BuildContext context, MedicalFile file) async {
    final bool hasLocalFile = file.hasLocalFile;
    final bool hasRemoteFile = file.hasRemoteFile;

    if (!hasLocalFile && !hasRemoteFile) {
      messages(
        context,
        'cannot_show_medical_file'.tr(context),
        AppColors.redColor,
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        return Dialog(
          backgroundColor: AppColors.transparentColor,
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              file.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                _TypeBadge(type: file.type),
                                if (file.resolvedSourceLabel.isNotEmpty)
                                  _FileMetaChip(
                                    icon: Icons.verified_outlined,
                                    text: file.resolvedSourceLabel,
                                  ),
                                _FileMetaChip(
                                  icon: Icons.calendar_month_rounded,
                                  text:
                                      '${"date".tr(context)}: ${dateFormat.format(file.fileDate)}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _DialogFilePreview(file: file),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadMedicalFile(
    BuildContext context,
    MedicalFile file,
  ) async {
    try {
      final Directory targetDirectory = Directory(
        '${Directory.systemTemp.path}/tabiby_downloads',
      );
      if (!targetDirectory.existsSync()) {
        targetDirectory.createSync(recursive: true);
      }

      final String fileName = _buildDownloadFileName(file);
      final String targetPath = '${targetDirectory.path}/$fileName';

      if (file.localFile != null && file.localFile!.existsSync()) {
        await file.localFile!.copy(targetPath);
      } else if (file.remoteFileUrl != null && file.remoteFileUrl!.isNotEmpty) {
        await getit.get<Dio>().download(
          Urls.fixUrl(file.remoteFileUrl!),
          targetPath,
        );
      } else {
        throw Exception('missing_file');
      }

      if (!context.mounted) {
        return;
      }

      messages(
        context,
        '${"medical_file_downloaded_to".tr(context)} $targetPath',
        AppColors.greenColor,
        msgTime: 4,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      messages(
        context,
        'medical_file_download_failed'.tr(context),
        AppColors.redColor,
      );
    }
  }

  String _buildDownloadFileName(MedicalFile file) {
    final String normalizedTitle = file.title
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final String fileType = file.type == MedicalFileType.radiology
        ? 'radiology'
        : 'lab';
    final String extension = _resolveFileExtension(file);

    return '${normalizedTitle.isEmpty ? fileType : normalizedTitle}_${file.id}$extension';
  }

  String _resolveFileExtension(MedicalFile file) {
    final String? localPath = file.localFilePath;
    if (localPath != null && localPath.contains('.')) {
      return '.${localPath.split('.').last}';
    }

    final String? remotePath = file.remoteFileUrl;
    if (remotePath != null) {
      final Uri? uri = Uri.tryParse(remotePath);
      final String lastSegment = uri?.pathSegments.isNotEmpty == true
          ? uri!.pathSegments.last
          : '';
      if (lastSegment.contains('.')) {
        return '.${lastSegment.split('.').last}';
      }
    }

    final String? apiFilePath = file.filePath;
    if (apiFilePath != null && apiFilePath.contains('.')) {
      return '.${apiFilePath.split('.').last}';
    }

    return '.jpg';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalFiles,
    required this.radiologyCount,
    required this.labCount,
    required this.onAddPressed,
  });

  final int totalFiles;
  final int radiologyCount;
  final int labCount;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -30,
            right: 10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -45,
            left: 20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'medical_files_overview'.tr(context),
                            style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$totalFiles',
                            style: const TextStyle(
                              color: AppColors.titleColor,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'stored_medical_files'.tr(context),
                            style: TextStyle(
                              color: AppColors.grey700Color,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _HeaderActionButton(
                      text: 'add_medical_file'.tr(context),
                      onPressed: onAddPressed,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'open_saved_medical_files'.tr(context),
                  style: TextStyle(color: AppColors.grey700Color, height: 1.45),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _FileCountChip(
                      icon: Icons.image_search_rounded,
                      label: 'radiology_file'.tr(context),
                      count: radiologyCount,
                    ),
                    _FileCountChip(
                      icon: Icons.science_rounded,
                      label: 'lab_file'.tr(context),
                      count: labCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryColors,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.whiteColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.whiteColor,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileCountChip extends StatelessWidget {
  const _FileCountChip({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: AppColors.primaryColors, size: 18),
          const SizedBox(width: 8),
          Text(
            '$count $label',
            style: const TextStyle(
              color: AppColors.primaryColors,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'open_saved_medical_files'.tr(context),
            style: TextStyle(
              color: AppColors.grey700Color,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selectedFilter, required this.onChanged});

  final MedicalFilesFilter selectedFilter;
  final ValueChanged<MedicalFilesFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: MedicalFilesFilter.values.map((MedicalFilesFilter filter) {
        final bool isSelected = selectedFilter == filter;

        return ChoiceChip(
          label: Text(
            filter.labelKey.tr(context),
            style: TextStyle(
              color: isSelected ? AppColors.whiteColor : AppColors.grey700Color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(filter),

          showCheckmark: false,
          selectedColor: AppColors.primaryColors,
          backgroundColor: AppColors.grey50Color,
          elevation: 0,
          pressElevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: isSelected
                  ? AppColors.transparentColor
                  : AppColors.grey300Color,
              width: 1.0,
            ),
          ),
          // --------------------------------------
        );
      }).toList(),
    );
  }
}

class _MedicalFileCard extends StatelessWidget {
  const _MedicalFileCard({
    required this.file,
    required this.onDownload,
    required this.onShow,
  });

  final MedicalFile file;
  final VoidCallback onDownload;
  final VoidCallback onShow;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MedicalFilePreview(file: file),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            file.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeBadge(type: file.type),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (file.resolvedSourceLabel.isNotEmpty)
                          _FileMetaChip(
                            icon: Icons.verified_outlined,
                            text: file.resolvedSourceLabel,
                          ),
                        _FileMetaChip(
                          icon: Icons.calendar_month_rounded,
                          text:
                              '${"date".tr(context)}: ${dateFormat.format(file.fileDate)}',
                        ),
                        if (file.createdAt != null)
                          _FileMetaChip(
                            icon: Icons.schedule_rounded,
                            text:
                                '${"added_on".tr(context)}: ${dateFormat.format(file.createdAt!)}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _ActionButton(
                  icon: Icons.download_rounded,
                  text: 'download'.tr(context),
                  onPressed: onDownload,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  text: 'show'.tr(context),
                  onPressed: onShow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FileMetaChip extends StatelessWidget {
  const _FileMetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.appBackgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: AppColors.primaryColors),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppColors.grey700Color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalFilePreview extends StatelessWidget {
  const _MedicalFilePreview({required this.file});

  final MedicalFile file;

  @override
  Widget build(BuildContext context) {
    final File? localFile = file.localFile;

    if (localFile != null && localFile.existsSync() && file.isImage) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(
            localFile,
            height: 90,
            width: 90,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (file.hasRemoteFile && file.isImage) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CustomImageWidget(
            imageUrl: file.remoteFileUrl,
            placeholderAsset: AssetsData.defaultCenter,
            height: 90,
            width: 90,
          ),
        ),
      );
    }

    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: file.type == MedicalFileType.radiology
              ? <Color>[
                  AppColors.blueGreyColor.withValues(alpha: 0.16),
                  AppColors.greyColor.withValues(alpha: 0.1),
                ]
              : <Color>[
                  AppColors.primaryColors.withValues(alpha: 0.16),
                  AppColors.secColors.withValues(alpha: 0.08),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        file.type == MedicalFileType.radiology
            ? (file.isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.image_outlined)
            : Icons.description_outlined,
        color: file.type == MedicalFileType.radiology
            ? AppColors.grey700Color
            : Theme.of(context).primaryColor,
        size: 34,
      ),
    );
  }
}

class _DialogFilePreview extends StatelessWidget {
  const _DialogFilePreview({required this.file});

  final MedicalFile file;

  @override
  Widget build(BuildContext context) {
    if (file.hasLocalFile && file.isImage) {
      return InkWell(
        onTap: () => _openZoomableMedicalImageViewer(context, file),
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.file(file.localFile!, fit: BoxFit.contain),
            ),
            const Positioned(top: 12, right: 12, child: _ExpandHintBadge()),
          ],
        ),
      );
    }

    if (file.hasRemoteFile && file.isImage) {
      return InkWell(
        onTap: () => _openZoomableMedicalImageViewer(context, file),
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomImageWidget(
                imageUrl: file.remoteFileUrl,
                placeholderAsset: AssetsData.defaultCenter,
                fit: BoxFit.contain,
              ),
            ),
            const Positioned(top: 12, right: 12, child: _ExpandHintBadge()),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              file.isPdf
                  ? Icons.picture_as_pdf_rounded
                  : Icons.insert_drive_file_rounded,
              color: file.isPdf
                  ? AppColors.destructiveColor
                  : AppColors.primaryColors,
              size: 46,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            file.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          const SizedBox(height: 10),
          Text(
            file.isPdf
                ? 'pdf_preview_not_available'.tr(context)
                : 'cannot_show_medical_file'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey700Color, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ExpandHintBadge extends StatelessWidget {
  const _ExpandHintBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blackColor.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.open_in_full_rounded,
            size: 16,
            color: AppColors.whiteColor,
          ),
          const SizedBox(width: 6),
          Text(
            'zoom'.tr(context),
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openZoomableMedicalImageViewer(
  BuildContext context,
  MedicalFile file,
) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: AppBar(
            backgroundColor: AppColors.blackColor,
            foregroundColor: AppColors.whiteColor,
            elevation: 0,
            title: Text(
              file.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'medical_image_zoom_hint'.tr(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.white70Color),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    panEnabled: true,
                    child: Center(
                      child: file.hasLocalFile
                          ? Image.file(file.localFile!, fit: BoxFit.contain)
                          : CustomImageWidget(
                              imageUrl: file.remoteFileUrl,
                              placeholderAsset: AssetsData.defaultCenter,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final MedicalFileType type;

  @override
  Widget build(BuildContext context) {
    final bool isRadiology = type == MedicalFileType.radiology;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRadiology
            ? AppColors.greyColor.withValues(alpha: 0.14)
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type.labelKey.tr(context),
        style: TextStyle(
          color: isRadiology
              ? AppColors.grey800Color
              : Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyMedicalFilesState extends StatelessWidget {
  const _EmptyMedicalFilesState({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              size: 42,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'no_medical_files_title'.tr(context),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'no_medical_files_subtitle'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey600Color, height: 1.5),
          ),
          const SizedBox(height: 20),
          _ActionButton(
            icon: Icons.add_circle_outline_rounded,
            text: 'add_medical_file'.tr(context),
            onPressed: onAddPressed,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = isPrimary
        ? AppColors.whiteColor
        : AppColors.primaryColors;

    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primaryColors : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18),
            border: isPrimary
                ? null
                : Border.all(
                    color: AppColors.primaryColors.withValues(alpha: 0.3),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: foregroundColor, size: 19),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
