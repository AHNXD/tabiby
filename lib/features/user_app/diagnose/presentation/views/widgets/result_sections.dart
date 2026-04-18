import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';

class DiagnosisResultContent extends StatelessWidget {
  const DiagnosisResultContent({
    super.key,
    required this.result,
    required this.onFindDoctor,
    required this.onStartOver,
  });

  final DiagnosisResult result;
  final VoidCallback onFindDoctor;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final Color urgencyColor = _urgencyColor(result.urgency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (result.isEmergency) ...[
          const EmergencyWarningBanner(),
          const SizedBox(height: 16),
        ],
        DiagnosisSummaryCard(result: result, urgencyColor: urgencyColor),
        const SizedBox(height: 14),
        DiagnosisTextSection(
          titleKey: 'reasoning',
          icon: Icons.psychology_alt_outlined,
          content: result.reasoning,
        ),
        const SizedBox(height: 14),
        DiagnosisNextStepsSection(steps: result.adviceSteps),
        const SizedBox(height: 24),
        PrimaryButton(
          onPressed: onFindDoctor,
          text: 'view_doctors'.tr(context),
          fontSize: 20,
        ),
        const SizedBox(height: 12),
        SecondryButton(
          onPressed: onStartOver,
          text: 'start_new_diagnosis'.tr(context),
        ),
      ],
    );
  }

  Color _urgencyColor(String urgency) {
    switch (urgency.toUpperCase()) {
      case 'EMERGENCY':
      case 'HIGH':
        return AppColors.dangerAccentColor;
      case 'MEDIUM':
        return AppColors.warningAccentColor;
      default:
        return AppColors.primaryColors;
    }
  }
}

class EmergencyWarningBanner extends StatelessWidget {
  const EmergencyWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerSurfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.dangerAccentColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dangerAccentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.dangerAccentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.dangerAccentColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'emergency_msg'.tr(context),
              style: TextStyle(
                color: AppColors.dangerDeepColor,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosisSummaryCard extends StatelessWidget {
  const DiagnosisSummaryCard({
    super.key,
    required this.result,
    required this.urgencyColor,
  });

  final DiagnosisResult result;
  final Color urgencyColor;

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
            bottom: 26,
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
                        color: urgencyColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.medical_information_outlined,
                        color: urgencyColor,
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
                        color: urgencyColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _localizedUrgency(context, result.urgency),
                        style: TextStyle(
                          color: urgencyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'possible_condition'.tr(context),
                  style: TextStyle(
                    color: AppColors.grey600Color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  result.conditionName,
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _ResultStatCard(
                          icon: Icons.percent_rounded,
                          label: 'confidence'.tr(context),
                          value: result.confidence,
                          accentColor: urgencyColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultStatCard(
                          icon: Icons.local_hospital_outlined,
                          label: 'recommended_specialty'.tr(context),
                          value: result.specialist,
                          accentColor: AppColors.primaryColors,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedUrgency(BuildContext context, String urgency) {
    switch (urgency.toUpperCase()) {
      case 'EMERGENCY':
        return 'diagnose_urgency_emergency'.tr(context);
      case 'HIGH':
        return 'diagnose_urgency_high'.tr(context);
      case 'MEDIUM':
        return 'diagnose_urgency_medium'.tr(context);
      case 'LOW':
        return 'diagnose_urgency_low'.tr(context);
      default:
        return urgency;
    }
  }
}

class DiagnosisTextSection extends StatelessWidget {
  const DiagnosisTextSection({
    super.key,
    required this.titleKey,
    required this.icon,
    required this.content,
  });

  final String titleKey;
  final IconData icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return _DiagnosisSectionCard(
      icon: icon,
      title: titleKey.tr(context),
      child: Text(
        content,
        style: TextStyle(color: AppColors.grey700Color, height: 1.65),
      ),
    );
  }
}

class DiagnosisNextStepsSection extends StatelessWidget {
  const DiagnosisNextStepsSection({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return _DiagnosisSectionCard(
      icon: Icons.route_outlined,
      title: 'next_steps'.tr(context),
      child: steps.isEmpty
          ? Text(
              'no_data_subtitle'.tr(context),
              style: TextStyle(color: AppColors.grey600Color),
            )
          : Column(
              children: steps.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == steps.length - 1 ? 0 : 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColors.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: AppColors.primaryColors,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: AppColors.grey700Color,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class DiagnosisNoResultView extends StatelessWidget {
  const DiagnosisNoResultView({super.key, required this.onStartOver});

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
                'couldnt_get_condition'.tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'conflicting_symptoms'.tr(context),
                style: TextStyle(color: AppColors.grey600Color, height: 1.55),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: onStartOver,
                text: 'start_new_diagnosis'.tr(context),
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagnosisSectionCard extends StatelessWidget {
  const _DiagnosisSectionCard({
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primaryColors, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.titleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ResultStatCard extends StatelessWidget {
  const _ResultStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 98),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.grey600Color,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
