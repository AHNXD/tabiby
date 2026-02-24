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
        DiagnosisTextSection(titleKey: 'reasoning', content: result.reasoning),
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
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      default:
        return Colors.green;
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
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'emergency_msg'.tr(context),
              style: TextStyle(
                color: Colors.red.shade800,
                fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: urgencyColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _localizedUrgency(context, result.urgency),
                  style: TextStyle(
                    color: urgencyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${'confidence'.tr(context)}: ${result.confidence}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'possible_condition'.tr(context),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.conditionName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 14),
          ResultInfoRow(
            icon: Icons.local_hospital_outlined,
            title: 'recommended_specialty'.tr(context),
            value: result.specialist,
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
    required this.content,
  });

  final String titleKey;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleKey.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class DiagnosisNextStepsSection extends StatelessWidget {
  const DiagnosisNextStepsSection({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'next_steps'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (steps.isEmpty)
            Text(
              'no_data_subtitle'.tr(context),
              style: TextStyle(color: Colors.grey.shade600),
            )
          else
            ...steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: TextStyle(
                        color: AppColors.primaryColors,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 44,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'couldnt_get_condition'.tr(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'conflicting_symptoms'.tr(context),
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
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
    );
  }
}

class ResultInfoRow extends StatelessWidget {
  const ResultInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColors),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
