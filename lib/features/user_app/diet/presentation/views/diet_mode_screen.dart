import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/ai_usage/ai_usage_cubit.dart';
import 'package:tabiby/core/models/ai_usage_models.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/diet_result_screen.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/widgets/diet_mode_sections.dart';

import '../view_models/diet_cubit.dart';
import 'diet_plan_form_screen.dart';

class DietModeScreen extends StatelessWidget {
  const DietModeScreen({super.key});

  static const routeName = '/diet-mode';

  @override
  Widget build(BuildContext context) {
    return BlocListener<DietCubit, DietState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage.isNotEmpty,
      listener: (context, state) {
        messages(context, state.errorMessage.tr(context), AppColors.redColor);
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(
          title: 'diet_mode_title'.tr(context),
          showBackButton: false,
        ),
        body: BlocBuilder<DietCubit, DietState>(
          builder: (context, state) {
            return BlocBuilder<AiUsageCubit, AiUsageState>(
              builder: (context, usageState) {
                final dietUsage =
                    usageState.remainingByFeature[AiFeatureType.programDiet];

                String usageTextFor(AiFeatureUsageLimit? usage) {
                  if (usage == null) return '';
                  return '${'ai_usage_used'.tr(context)}: ${usage.used}/${usage.limit} • ${'ai_usage_remaining'.tr(context)}: ${usage.remaining}';
                }

                void openDietForm(bool isSpecialist) {
                  context.read<DietCubit>().clearError();

                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DietPlanFormScreen(isSpecialist: isSpecialist),
                      ),
                    );
                  }
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    DietModeHeroCard(
                      title: 'diet_mode_title'.tr(context),
                      subtitle: 'diet_mode_choose_generation'.tr(context),
                      historyCount: state.history.length,
                      latestCalories: state.history.isNotEmpty
                          ? state.history.first.plan.dailyCaloriesTarget
                          : null,
                    ),
                    const SizedBox(height: 14),
                    if (state.isGenerating)
                      DietInfoBanner(
                        text: 'diet_mode_loading_info'.tr(context),
                      ),
                    if (state.isLoadingHistory && state.history.isEmpty)
                      DietInfoBanner(
                        text: 'diet_mode_loading_history'.tr(context),
                        icon: Icons.history_rounded,
                      ),
                    if (state.isLoadingPlan)
                      DietInfoBanner(
                        text: 'diet_mode_loading_plan'.tr(context),
                        icon: Icons.description_outlined,
                      ),
                    if (state.history.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      DietActionCard(
                        icon: Icons.description_outlined,
                        title: 'diet_mode_view_latest_plan'.tr(context),
                        subtitle: 'diet_mode_view_latest_plan_subtitle'.tr(
                          context,
                        ),
                        onTap: () async {
                          context.read<DietCubit>().clearError();
                          final opened = await context
                              .read<DietCubit>()
                              .openLatestPlan();
                          if (opened && context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const DietResultScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      'diet_mode_choose_generation'.tr(context),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900Color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DietModeCard(
                      title: 'diet_mode_basic_title'.tr(context),
                      subtitle: 'diet_mode_basic_subtitle'.tr(context),
                      icon: Icons.person_outline,
                      usageText: usageTextFor(dietUsage),
                      isEnabled: true,
                      onTap: () => openDietForm(false),
                    ),
                    const SizedBox(height: 12),
                    DietModeCard(
                      title: 'diet_mode_advanced_title'.tr(context),
                      subtitle: 'diet_mode_advanced_subtitle'.tr(context),
                      icon: Icons.medical_services_outlined,
                      usageText: usageTextFor(dietUsage),
                      isEnabled: true,
                      onTap: () => openDietForm(true),
                    ),
                    if (state.historyStatus == DietAsyncStatus.error &&
                        state.history.isEmpty) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.read<DietCubit>().loadHistory(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('try_again'.tr(context)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColors,
                        ),
                      ),
                    ],
                    if (state.history.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'diet_mode_previous_plans'.tr(context),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...state.history
                          .take(6)
                          .map(
                            (item) => DietHistoryCard(
                              item: item,
                              onOpenPlan: () async {
                                context.read<DietCubit>().clearError();
                                final opened = await context
                                    .read<DietCubit>()
                                    .openHistoryItem(item);
                                if (opened && context.mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const DietResultScreen(),
                                    ),
                                  );
                                }
                              },
                              onReuseValues: () {
                                context.read<DietCubit>().setCurrentRequest(
                                  item.request,
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DietPlanFormScreen(
                                      isSpecialist: item.request.isSpecialist,
                                      initialRequest: item.request,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    ],
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
