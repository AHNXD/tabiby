import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/error_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result';
  const ResultScreen({super.key});

  void _startOver(BuildContext context) {
    context.read<DiagnosisCubit>().resetDiagnosis();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  // Placeholder for the new primary action
  void _findDoctor(BuildContext context, String specialty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(specialty),
        backgroundColor: AppColors.primaryColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'result_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.resultState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return ErrorView(
                message: state.errorMessage,
                // Give a more helpful retry text
                onRetry: () => _startOver(context),
              );
            case ViewState.success:
              if (state.diagnosisResult == null ||
                  !state.diagnosisResult!.success) {
                return _buildNoResult(context, state.diagnosisResult?.message);
              }

              return _buildResultView(context, state.diagnosisResult!.result!);
            default:
              // Fallback for initial state
              return const LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildResultView(BuildContext context, ResultData result) {
    final theme = Theme.of(context);
    final confidenceValue = result.confidence / 100; // e.g., 85.0 -> 0.85

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Enhanced Emergency Banner ---
        if (result.emergency)
          Card(
            color: theme.colorScheme.errorContainer,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: theme.colorScheme.onErrorContainer,
                    size: 30,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      'emergency'.tr(context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // --- Main Result Card ---
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'condition'.tr(context),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  result.name,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColors,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Confidence Visual ---
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'confidence'.tr(context),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12.0),
                          _buildConfidenceIndicator(
                            context,
                            confidenceValue,
                            result.confidence.toStringAsFixed(0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    // --- Specialty Info ---
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'recommended_specialty'.tr(context),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            result.specialty,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24.0),

        // --- Primary & Secondary CTAs ---
        PrimaryButton(
          onPressed: () => _findDoctor(context, result.specialty),

          text: '${"find_a".tr(context)} ${result.specialty}',
        ),
        const SizedBox(height: 12.0),
        SecondryButton(
          onPressed: () => _startOver(context),

          text: 'start_new_diagnosis'.tr(context),
        ),
        const SizedBox(height: 24.0),

        // --- Disclaimer ---
        Card(
          color: theme.colorScheme.secondary.withValues(alpha: 0.05),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'disclaimer_note'.tr(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper for the "No Result" view
  Widget _buildNoResult(BuildContext context, String? message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 20),
            Text(
              message ?? 'couldnt_get_condition'.tr(context),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'conflicting_symptoms'.tr(context),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _startOver(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'start_new_diagnosis'.tr(context),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the confidence indicator
  Widget _buildConfidenceIndicator(
    BuildContext context,
    double value,
    String percentText,
  ) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1.0, // The background track
            strokeWidth: 8,
            color: AppColors.secColors.withValues(alpha: 0.1),
          ),
          CircularProgressIndicator(
            value: value, // The foreground progress
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            color: AppColors.primaryColors,
          ),
          Center(
            child: Text(
              '$percentText%',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
