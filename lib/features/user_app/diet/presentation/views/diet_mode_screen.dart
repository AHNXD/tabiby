import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/diet_result_screen.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/widgets/diet_mode_sections.dart';

import '../view_models/diet_cubit.dart';
import 'diet_plan_form_screen.dart';

class DietModeScreen extends StatelessWidget {
  const DietModeScreen({super.key});

  static const routeName = '/diet-mode';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppbar(
        title: 'diet_mode_title'.tr(context),
        showBackButton: false,
      ),
      body: BlocBuilder<DietCubit, DietState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'diet_mode_choose_generation'.tr(context),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 14),
              if (state.isLoading)
                DietInfoBanner(text: 'diet_mode_loading_info'.tr(context)),
              if (state.plan != null) ...[
                const SizedBox(height: 10),
                DietActionCard(
                  icon: Icons.description_outlined,
                  title: 'diet_mode_view_latest_plan'.tr(context),
                  subtitle: 'diet_mode_view_latest_plan_subtitle'.tr(context),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DietResultScreen(),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 14),
              DietModeCard(
                title: 'diet_mode_basic_title'.tr(context),
                subtitle: 'diet_mode_basic_subtitle'.tr(context),
                icon: Icons.person_outline,
                onTap: () {
                  context.read<DietCubit>().clearError();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const DietPlanFormScreen(isSpecialist: false),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DietModeCard(
                title: 'diet_mode_advanced_title'.tr(context),
                subtitle: 'diet_mode_advanced_subtitle'.tr(context),
                icon: Icons.medical_services_outlined,
                onTap: () {
                  context.read<DietCubit>().clearError();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const DietPlanFormScreen(isSpecialist: true),
                    ),
                  );
                },
              ),
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
                        onOpenPlan: () {
                          context.read<DietCubit>().openHistoryItem(item);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DietResultScreen(),
                            ),
                          );
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
      ),
    );
  }
}
