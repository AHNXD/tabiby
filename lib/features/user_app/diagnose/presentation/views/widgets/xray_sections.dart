import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabiby/core/Api_services/urls.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/xray_diagnosis_result_model.dart';

class XrayHeroCard extends StatelessWidget {
  const XrayHeroCard({
    super.key,
    required this.hasSelectedImage,
    required this.hasResult,
  });

  final bool hasSelectedImage;
  final bool hasResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.image_search_rounded,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (hasSelectedImage || hasResult
                                    ? AppColors.primaryColors
                                    : AppColors.grey500Color)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        (hasResult
                                ? 'xray_status_result_ready'
                                : hasSelectedImage
                                ? 'xray_status_image_ready'
                                : 'xray_status_waiting')
                            .tr(context),
                        style: TextStyle(
                          color: hasSelectedImage || hasResult
                              ? AppColors.primaryColors
                              : AppColors.grey700Color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'xray_diagnosis_title'.tr(context),
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'xray_diagnosis_subtitle'.tr(context),
                  style: TextStyle(
                    color: AppColors.grey700Color,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
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

class XrayUploadCard extends StatelessWidget {
  const XrayUploadCard({
    super.key,
    required this.imagePath,
    required this.onPick,
    this.onClear,
    this.selectedTitle,
  });

  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final String? selectedTitle;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imagePath != null && imagePath!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasImage
              ? AppColors.primaryColors.withValues(alpha: 0.35)
              : AppColors.grey200Color,
          width: hasImage ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasImage) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 56,
                  color: AppColors.primaryColors.withValues(alpha: 0.85),
                ),
                const SizedBox(height: 14),
                Text(
                  'xray_upload_title'.tr(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'xray_upload_hint'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.45, color: AppColors.grey600Color),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColors.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'xray_upload_action'.tr(context),
                      style: const TextStyle(
                        color: AppColors.primaryColors,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: Image.file(File(imagePath!), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'xray_upload_ready'.tr(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.titleColor,
                            ),
                          ),
                          if (selectedTitle != null &&
                              selectedTitle!.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${'xray_selected_source'.tr(context)}: $selectedTitle',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grey600Color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onPick,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text('xray_change_image'.tr(context)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColors,
                      ),
                    ),
                  ],
                ),
                if (selectedTitle != null &&
                    selectedTitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColors.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.folder_shared_outlined,
                          size: 18,
                          color: AppColors.primaryColors,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'xray_selected_from_medical_files'.tr(context),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (onClear != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: Text('remove'.tr(context)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.dangerAccentColor,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showXrayImageSourceSheet(
  BuildContext context,
  ValueChanged<ImageSource> onImageSourceSelected,
) {
  return showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Text(
                'xray_source_sheet_title'.tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('xray_pick_from_gallery'.tr(context)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onImageSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text('xray_take_photo'.tr(context)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onImageSourceSelected(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class XrayAnalyzeButton extends StatelessWidget {
  const XrayAnalyzeButton({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: isEnabled
              ? [
                  AppColors.primaryColors,
                  AppColors.primaryColors.withValues(alpha: 0.82),
                ]
              : [AppColors.grey400Color, AppColors.grey300Color],
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primaryColors.withValues(alpha: 0.24),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparentColor,
          disabledBackgroundColor: AppColors.transparentColor,
          shadowColor: AppColors.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                  strokeWidth: 2.4,
                ),
              )
            : Text(
                'xray_analyze_button'.tr(context),
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class XrayDiagnosisResultContent extends StatelessWidget {
  const XrayDiagnosisResultContent({
    super.key,
    required this.result,
    required this.onStartOver,
  });

  final XrayDiagnosisResult result;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        XraySummaryCard(result: result),
        const SizedBox(height: 14),
        XrayHeatmapSection(heatmapUrl: result.heatmapUrl),
        if (result.sortedFindings.isNotEmpty) ...[
          const SizedBox(height: 14),
          XrayFindingsGridSection(results: result.sortedFindings),
        ],
        const SizedBox(height: 14),
        XrayNarrativeSection(aiAnalysisText: result.aiDiagnosis),
        const SizedBox(height: 24),
        PrimaryButton(
          onPressed: onStartOver,
          text: 'xray_start_new_analysis'.tr(context),
          fontSize: 20,
        ),
      ],
    );
  }
}

class XraySummaryCard extends StatelessWidget {
  const XraySummaryCard({super.key, required this.result});

  final XrayDiagnosisResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.primaryColors,
                  size: 28,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'xray_result_ready'.tr(context),
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'xray_top_finding'.tr(context),
            style: TextStyle(
              color: AppColors.grey600Color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            result.topDisease,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _XrayStatCard(
                  icon: Icons.percent_rounded,
                  label: 'confidence'.tr(context),
                  value: '${(result.topProbability * 100).toStringAsFixed(0)}%',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _XrayStatCard(
                  icon: Icons.analytics_outlined,
                  label: 'xray_findings_count'.tr(context),
                  value: result.sortedFindings.length.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class XrayHeatmapSection extends StatelessWidget {
  const XrayHeatmapSection({super.key, this.heatmapUrl});

  final String? heatmapUrl;

  @override
  Widget build(BuildContext context) {
    if (heatmapUrl == null || heatmapUrl!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return _XraySectionCard(
      icon: Icons.image_search_rounded,
      title: 'xray_heatmap_title'.tr(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1.2,
          child: Image.network(
            Urls.fixUrl(heatmapUrl!),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.grey100Color,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.grey500Color,
                  size: 40,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class XrayFindingsGridSection extends StatelessWidget {
  const XrayFindingsGridSection({super.key, required this.results});

  final List<MapEntry<String, double>> results;

  @override
  Widget build(BuildContext context) {
    return _XraySectionCard(
      icon: Icons.grid_view_rounded,
      title: 'xray_findings_title'.tr(context),
      child: results.isEmpty
          ? Text(
              'xray_no_findings'.tr(context),
              style: TextStyle(color: AppColors.grey600Color),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final MapEntry<String, double> entry = results[index];
                return XrayFindingCard(
                  disease: entry.key,
                  probability: entry.value,
                );
              },
            ),
    );
  }
}

class XrayFindingCard extends StatelessWidget {
  const XrayFindingCard({
    super.key,
    required this.disease,
    required this.probability,
  });

  final String disease;
  final double probability;

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    if (probability >= 0.79) {
      cardColor = AppColors.dangerAccentColor;
    } else if (probability > 0.6) {
      cardColor = AppColors.warningAccentColor;
    } else {
      cardColor = AppColors.primaryColors;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(
                  value: probability,
                  strokeWidth: 5,
                  color: cardColor,
                  backgroundColor: cardColor.withValues(alpha: 0.12),
                ),
              ),
              Text(
                '${(probability * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: cardColor, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            disease,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class XrayNarrativeSection extends StatelessWidget {
  const XrayNarrativeSection({super.key, required this.aiAnalysisText});

  final String aiAnalysisText;

  @override
  Widget build(BuildContext context) {
    if (aiAnalysisText.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(aiAnalysisText);

    return _XraySectionCard(
      icon: Icons.auto_awesome_outlined,
      title: 'xray_ai_summary_title'.tr(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            aiAnalysisText,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(color: AppColors.grey700Color, height: 1.65),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.warningSurfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'xray_disclaimer'.tr(context),
              style: const TextStyle(
                color: AppColors.warningDeepColor,
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class XrayNoResultView extends StatelessWidget {
  const XrayNoResultView({super.key, required this.onStartOver});

  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.grey200Color),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.dangerAccentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 44,
                  color: AppColors.dangerAccentColor,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'xray_no_result_title'.tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'xray_no_result_subtitle'.tr(context),
                style: TextStyle(color: AppColors.grey600Color, height: 1.55),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: onStartOver,
                text: 'xray_start_new_analysis'.tr(context),
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _XrayStatCard extends StatelessWidget {
  const _XrayStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryColors, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey600Color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _XraySectionCard extends StatelessWidget {
  const _XraySectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryColors, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
