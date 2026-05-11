import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/ai_usage/ai_usage_cubit.dart';
import 'package:tabiby/core/models/ai_usage_models.dart';

import '../view_models/diagnosis_cubit.dart';
import 'category_screen.dart';
import 'chest_xray_diagnosis_screen.dart';
import 'widgets/diagnose_mode_sections.dart';

class DiagnoseModeScreen extends StatelessWidget {
  const DiagnoseModeScreen({super.key});

  static const routeName = '/diagnose-mode';

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiagnosisCubit, DiagnosisState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage.isNotEmpty,
      listener: (context, state) {
        messages(context, state.errorMessage.tr(context), AppColors.redColor);
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(
          title: 'diagnose'.tr(context),
          showBackButton: false,
        ),
        body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
          builder: (context, state) {
            return BlocBuilder<AiUsageCubit, AiUsageState>(
              builder: (context, usageState) {
                final diagnosisUsage =
                    usageState.remainingByFeature[AiFeatureType.diagnosis];
                final xrayUsage =
                    usageState.remainingByFeature[AiFeatureType.xrayAnalysis];

                String usageTextFor(AiFeatureUsageLimit? usage) {
                  if (usage == null) return '';
                  return '${'ai_usage_used'.tr(context)}: ${usage.used}/${usage.limit} • ${'ai_usage_remaining'.tr(context)}: ${usage.remaining}';
                }

                final bool diagnosisBlocked =
                    diagnosisUsage != null && diagnosisUsage.remaining <= 0;
                final bool xrayBlocked =
                    xrayUsage != null && xrayUsage.remaining <= 0;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    DiagnoseModeHeroCard(
                      hasSymptomResult: state.diagnosisResult != null,
                      hasXrayResult: state.xrayDiagnosisResult != null,
                    ),
                    const SizedBox(height: 16),
                    DiagnoseModeEntryCard(
                      icon: Icons.health_and_safety_outlined,
                      titleKey: 'diagnose_mode_symptom_title',
                      subtitleKey: 'diagnose_mode_symptom_subtitle',
                      statusKey: state.diagnosisResult != null
                          ? 'diagnose_mode_status_symptom_ready'
                          : null,
                      usageText: usageTextFor(diagnosisUsage),
                      isEnabled: !diagnosisBlocked,
                      onTap: () async {
                        context.read<DiagnosisCubit>().clearError();

                        final ok = await context
                            .read<AiUsageCubit>()
                            .canNavigateToFeature(AiFeatureType.diagnosis);
                        if (!ok && context.mounted) {
                          messages(
                            context,
                            'ai_usage_limit_reached'.tr(context),
                            AppColors.orangeColor,
                          );
                          return;
                        }

                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CategoryScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DiagnoseModeEntryCard(
                      icon: Icons.image_search_rounded,
                      titleKey: 'diagnose_mode_xray_title',
                      subtitleKey: 'diagnose_mode_xray_subtitle',
                      statusKey: state.xrayDiagnosisResult != null
                          ? 'diagnose_mode_status_xray_ready'
                          : null,
                      usageText: usageTextFor(xrayUsage),
                      isEnabled: !xrayBlocked,
                      onTap: () async {
                        context.read<DiagnosisCubit>().clearError();

                        final ok = await context
                            .read<AiUsageCubit>()
                            .canNavigateToFeature(AiFeatureType.xrayAnalysis);
                        if (!ok && context.mounted) {
                          messages(
                            context,
                            'ai_usage_limit_reached'.tr(context),
                            AppColors.orangeColor,
                          );
                          return;
                        }

                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChestXrayDiagnosisScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
