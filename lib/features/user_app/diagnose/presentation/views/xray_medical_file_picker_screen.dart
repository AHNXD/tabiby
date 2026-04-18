import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/Api_services/urls.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';

class XrayMedicalFilePickerScreen extends StatelessWidget {
  const XrayMedicalFilePickerScreen({
    super.key,
    required this.files,
    this.selectedFileId,
  });

  final List<MedicalFile> files;
  final int? selectedFileId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'xray_pick_from_medical_files'.tr(context)),
      body: files.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'no_xray_records_available'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey600Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final MedicalFile file = files[index];
                final bool isSelected = file.id == selectedFileId;
                return _MedicalFileCard(
                  file: file,
                  isSelected: isSelected,
                  onTap: () => Navigator.of(context).pop(file),
                );
              },
            ),
    );
  }
}

class _MedicalFileCard extends StatelessWidget {
  const _MedicalFileCard({
    required this.file,
    required this.isSelected,
    required this.onTap,
  });

  final MedicalFile file;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors
                  : AppColors.grey200Color,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _MedicalFilePreview(file: file),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'radiology_file'.tr(context),
                      style: TextStyle(color: AppColors.grey700Color),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${'date'.tr(context)}: ${dateFormat.format(file.fileDate)}',
                      style: TextStyle(
                        color: AppColors.grey500Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (file.resolvedSourceLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        file.resolvedSourceLabel,
                        style: TextStyle(
                          color: AppColors.grey500Color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: isSelected
                    ? AppColors.primaryColors
                    : AppColors.grey400Color,
                size: isSelected ? 24 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicalFilePreview extends StatelessWidget {
  const _MedicalFilePreview({required this.file});

  final MedicalFile file;

  @override
  Widget build(BuildContext context) {
    if (file.remoteFileUrl != null && file.remoteFileUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CustomImageWidget(
          imageUrl: Urls.fixUrl(file.remoteFileUrl!),
          placeholderAsset: AssetsData.defaultCenter,
          height: 72,
          width: 72,
        ),
      );
    }

    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.primaryColors,
        size: 34,
      ),
    );
  }
}
