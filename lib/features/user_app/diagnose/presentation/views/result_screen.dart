import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/doctors/presentation/view/all_doctors_screen.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result';
  const ResultScreen({super.key});

  void _startOver(BuildContext context) {
    context.read<DiagnosisCubit>().resetDiagnosis();
    Navigator.of(context).pop();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _retry(BuildContext context) {
    context.read<DiagnosisCubit>().submitDiagnosis();
  }

  void _findDoctor(BuildContext context) {
    Navigator.pushNamed(context, AllDoctorsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppbar(title: 'result_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.resultState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () => _retry(context),
              );
            case ViewState.success:
              final DiagnosisResult? result = state.diagnosisResult;
              if (result == null) {
                return _buildNoResult(context);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildResultView(context, result),
              );
            case ViewState.idle:
              return const LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildResultView(BuildContext context, DiagnosisResult result) {
    final Color urgencyColor = _urgencyColor(result.urgency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (result.isEmergency) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
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
          ),
          const SizedBox(height: 16),
        ],
        Container(
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
                      result.urgency,
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
              _InfoRow(
                icon: Icons.local_hospital_outlined,
                title: 'recommended_specialty'.tr(context),
                value: result.specialist,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
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
                'reasoning'.tr(context),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.reasoning,
                style: TextStyle(color: Colors.grey.shade700, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              if (result.adviceSteps.isEmpty)
                Text(
                  'no_data_subtitle'.tr(context),
                  style: TextStyle(color: Colors.grey.shade600),
                )
              else
                ...result.adviceSteps.asMap().entries.map(
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
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          onPressed: () => _findDoctor(context),
          text: 'view_doctors'.tr(context),
          fontSize: 20,
        ),
        const SizedBox(height: 12),
        SecondryButton(
          onPressed: () => _startOver(context),
          text: 'start_new_diagnosis'.tr(context),
        ),
      ],
    );
  }

  Widget _buildNoResult(BuildContext context) {
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
              onPressed: () => _startOver(context),
              text: 'start_new_diagnosis'.tr(context),
              fontSize: 20,
            ),
          ],
        ),
      ),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

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
