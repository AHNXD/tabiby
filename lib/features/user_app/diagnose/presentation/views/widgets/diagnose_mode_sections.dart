import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class DiagnoseModeHeroCard extends StatelessWidget {
  const DiagnoseModeHeroCard({
    super.key,
    required this.hasSymptomResult,
    required this.hasXrayResult,
  });

  final bool hasSymptomResult;
  final bool hasXrayResult;

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
                        Icons.psychology_alt_outlined,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    if (hasSymptomResult || hasXrayResult)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (hasSymptomResult)
                            const _ModeStatusChip(
                              icon: Icons.health_and_safety_outlined,
                              textKey: 'diagnose_mode_status_symptom_ready',
                            ),
                          if (hasXrayResult)
                            const _ModeStatusChip(
                              icon: Icons.image_search_rounded,
                              textKey: 'diagnose_mode_status_xray_ready',
                            ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'diagnose_mode_title'.tr(context),
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'diagnose_mode_subtitle'.tr(context),
                  style: TextStyle(
                    color: AppColors.grey700Color,
                    height: 1.5,
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

class DiagnoseModeEntryCard extends StatelessWidget {
  const DiagnoseModeEntryCard({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.onTap,
    this.statusKey,
    this.usageText,
    this.isEnabled = true,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final VoidCallback? onTap;
  final String? statusKey;
  final String? usageText;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool disabled = !isEnabled || onTap == null;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey200Color),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: disabled
                    ? AppColors.grey100Color
                    : AppColors.primaryColors.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: disabled
                    ? AppColors.grey500Color
                    : AppColors.primaryColors,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleKey.tr(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitleKey.tr(context),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.grey600Color,
                    ),
                  ),
                  if (usageText != null && usageText!.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      usageText!,
                      style: TextStyle(
                        color: disabled
                            ? AppColors.grey500Color
                            : AppColors.grey700Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (statusKey != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusKey!.tr(context),
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_rounded,
              color: disabled ? AppColors.grey300Color : AppColors.grey400Color,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeStatusChip extends StatelessWidget {
  const _ModeStatusChip({required this.icon, required this.textKey});

  final IconData icon;
  final String textKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColors),
          const SizedBox(width: 6),
          Text(
            textKey.tr(context),
            style: const TextStyle(
              color: AppColors.primaryColors,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
