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
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
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
              textColor: Colors.black,
              onRetry: () =>
                  context.read<MedicalFilesCubit>().loadMedicalFiles(),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<MedicalFilesCubit>().loadMedicalFiles(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: <Widget>[
                _SummaryCard(totalFiles: state.files.length, context: context),
                const SizedBox(height: 18),
                _FilterChips(
                  selectedFilter: state.filter,
                  onChanged: context.read<MedicalFilesCubit>().changeFilter,
                ),
                const SizedBox(height: 18),
                if (state.filteredFiles.isEmpty)
                  const _EmptyMedicalFilesState()
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

  Future<void> _showMedicalFile(BuildContext context, MedicalFile file) async {
    final bool hasLocalFile =
        file.localFile != null && file.localFile!.existsSync();
    final bool hasRemoteFile =
        file.remoteFileUrl != null && file.remoteFileUrl!.isNotEmpty;

    if (!hasLocalFile && !hasRemoteFile) {
      messages(context, 'cannot_show_medical_file'.tr(context), Colors.red);
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        file.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: hasLocalFile
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
        Colors.green,
        msgTime: 4,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      messages(context, 'medical_file_download_failed'.tr(context), Colors.red);
    }
  }

  String _buildDownloadFileName(MedicalFile file) {
    final String normalizedTitle = file.title
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final String fileType = file.type == MedicalFileType.xray ? 'xray' : 'lab';
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

    return '.jpg';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totalFiles, required this.context});
  Future<void> openAddScreen(BuildContext context) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider.value(
          value: context.read<MedicalFilesCubit>(),
          child: const AddMedicalFileScreen(),
        ),
      ),
    );
  }

  final int totalFiles;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColors,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'medical_files_overview'.tr(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$totalFiles',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'stored_medical_files'.tr(context),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Flexible(
            child: PrimaryButton(
              fontSize: 16,
              text: 'add_medical_file'.tr(context),
              onPressed: () => openAddScreen(context),
            ),
          ),
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
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(filter),

          showCheckmark: false,
          selectedColor: AppColors.primaryColors,
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          pressElevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _MedicalFilePreview(file: file),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            file.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeBadge(type: file.type),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${"date".tr(context)}: ${dateFormat.format(file.fileDate)}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${"added_on".tr(context)}: ${dateFormat.format(file.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SecondryButton(
                    fontSize: 16,
                    text: 'download'.tr(context),
                    onPressed: onDownload,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    fontSize: 16,
                    text: 'show'.tr(context),
                    onPressed: onShow,
                  ),
                ),
              ],
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

    if (localFile != null && localFile.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(localFile, height: 84, width: 84, fit: BoxFit.cover),
      );
    }

    if (file.remoteFileUrl != null && file.remoteFileUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomImageWidget(
          imageUrl: file.remoteFileUrl,
          placeholderAsset: AssetsData.defaultCenter,
          height: 84,
          width: 84,
        ),
      );
    }

    return Container(
      height: 84,
      width: 84,
      decoration: BoxDecoration(
        color: file.type == MedicalFileType.xray
            ? Colors.grey.withValues(alpha: 0.14)
            : Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        file.type == MedicalFileType.xray
            ? Icons.image_outlined
            : Icons.description_outlined,
        color: file.type == MedicalFileType.xray
            ? Colors.grey.shade700
            : Theme.of(context).primaryColor,
        size: 34,
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final MedicalFileType type;

  @override
  Widget build(BuildContext context) {
    final bool isXray = type == MedicalFileType.xray;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isXray
            ? Colors.grey.withValues(alpha: 0.14)
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type.labelKey.tr(context),
        style: TextStyle(
          color: isXray ? Colors.grey.shade800 : Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyMedicalFilesState extends StatelessWidget {
  const _EmptyMedicalFilesState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.folder_open_rounded,
            size: 40,
            color: Theme.of(context).primaryColor,
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
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }
}
