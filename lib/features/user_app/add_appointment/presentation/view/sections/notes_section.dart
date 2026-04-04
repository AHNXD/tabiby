import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';

import '../widgets/notes_field.dart';
import '../widgets/section_title.dart';

class NotesSection extends StatelessWidget {
  final TextEditingController noteController;
  final bool showDiagnosisOption;
  final bool sendDiagnosisResult;
  final ValueChanged<bool>? onToggleSendDiagnosis;
  final DiagnosisResult? diagnosisResult;

  const NotesSection({
    super.key,
    required this.noteController,
    this.showDiagnosisOption = false,
    this.sendDiagnosisResult = false,
    this.onToggleSendDiagnosis,
    this.diagnosisResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '4. ${"add_notes".tr(context)}'),
        if (showDiagnosisOption && diagnosisResult != null) ...[
          _DiagnosisShareCard(
            sendDiagnosisResult: sendDiagnosisResult,
            onToggle: onToggleSendDiagnosis,
            diagnosisResult: diagnosisResult!,
          ),
          const SizedBox(height: 14),
        ],
        NotesField(noteController: noteController),
      ],
    );
  }
}

class _DiagnosisShareCard extends StatelessWidget {
  const _DiagnosisShareCard({
    required this.sendDiagnosisResult,
    required this.onToggle,
    required this.diagnosisResult,
  });

  final bool sendDiagnosisResult;
  final ValueChanged<bool>? onToggle;
  final DiagnosisResult diagnosisResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.psychology_alt_outlined,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'booking_send_diagnosis_result'.tr(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2C28),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'booking_send_diagnosis_result_subtitle'.tr(context),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: sendDiagnosisResult,
                activeThumbColor: AppColors.primaryColors,
                activeTrackColor: AppColors.primaryColors.withValues(
                  alpha: 0.35,
                ),
                onChanged: onToggle,
              ),
            ],
          ),
          if (sendDiagnosisResult) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DiagnosisInfoChip(
                  icon: Icons.health_and_safety_outlined,
                  label: diagnosisResult.conditionName,
                ),
                _DiagnosisInfoChip(
                  icon: Icons.percent_rounded,
                  label:
                      '${'confidence'.tr(context)} ${diagnosisResult.confidence}',
                ),
                if (diagnosisResult.isEmergency)
                  _DiagnosisInfoChip(
                    icon: Icons.priority_high_rounded,
                    label: 'emergency'.tr(context),
                    isAlert: true,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DiagnosisInfoChip extends StatelessWidget {
  const _DiagnosisInfoChip({
    required this.icon,
    required this.label,
    this.isAlert = false,
  });

  final IconData icon;
  final String label;
  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    final Color color = isAlert
        ? const Color(0xFFE25F63)
        : AppColors.primaryColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
