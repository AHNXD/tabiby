import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_plan_response.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_request_data.dart';
import 'package:tabiby/features/user_app/diet/presentation/view_models/diet_cubit.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/widgets/diet_result_sections.dart';
import 'package:printing/printing.dart';

class DietResultScreen extends StatelessWidget {
  const DietResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'diet_result_title'.tr(context)),
      body: BlocConsumer<DietCubit, DietState>(
        listenWhen: (previous, current) =>
            previous.exportStatus != current.exportStatus,
        listener: (context, state) async {
          if (state.exportStatus == DietAsyncStatus.error &&
              state.exportErrorMessage.isNotEmpty) {
            messages(
              context,
              state.exportErrorMessage.tr(context),
              AppColors.redColor,
            );
            context.read<DietCubit>().clearExport();
            return;
          }

          if (state.exportStatus == DietAsyncStatus.success &&
              state.exportPdfBytes != null) {
            final String fileName = state.exportFileName.isNotEmpty
                ? state.exportFileName
                : 'diet_plan.pdf';
            try {
              await Printing.sharePdf(
                bytes: state.exportPdfBytes!,
                filename: fileName,
              );
            } catch (e) {
              if (!context.mounted) {
                return;
              }
              messages(context, e.toString(), AppColors.redColor);
            }
            if (context.mounted) {
              context.read<DietCubit>().clearExport();
            }
          }
        },
        builder: (context, state) {
          final DietPlanResponse? plan = state.plan;
          final DietRequestData? request = state.currentRequest;

          if (plan == null && (state.isGenerating || state.isLoadingPlan)) {
            return DietLoadingOnlyView(
              text: state.isLoadingPlan
                  ? 'diet_result_loading_selected_plan'.tr(context)
                  : 'diet_result_loading_only_message'.tr(context),
            );
          }

          if (plan == null) {
            return Center(child: Text('diet_result_no_plan_found'.tr(context)));
          }

          final List<MapEntry<String, DayPlan>> orderedEntries =
              _sortWeekEntries(plan.weekPlan.entries.toList());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.isGenerating)
                DietNoticeBanner(
                  text: 'diet_result_background_generation_message'.tr(context),
                ),
              DietOverviewCard(
                title: plan.dietTypeApplied.trim().isEmpty
                    ? 'diet_mode_fallback_plan_name'.tr(context)
                    : plan.dietTypeApplied,
                calories: plan.dailyCaloriesTarget,
                waterLiters: plan.dailyWaterLiters,
              ),
              const SizedBox(height: 10),
              DietMacrosCard(macros: plan.dailyMacrosSummary),
              const SizedBox(height: 10),
              DietSummaryCard(summary: plan.localizedSummary),
              if (request != null) ...[
                const SizedBox(height: 10),
                DietRequestValuesCard(request: request),
              ],
              const SizedBox(height: 14),
              Text(
                'diet_result_weekly_plan'.tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...orderedEntries.map(
                (entry) => DietDayPlanTile(day: entry.key, plan: entry.value),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: state.isExporting
                    ? null
                    : () => context.read<DietCubit>().exportCurrentPlanAsPdf(),
                icon: state.isExporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(
                  state.isExporting
                      ? 'diet_export_pdf_generating'.tr(context)
                      : 'diet_export_pdf'.tr(context),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColors,
                  side: BorderSide(
                    color: AppColors.primaryColors.withValues(alpha: 0.35),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                text: 'diet_result_back'.tr(context),
                fontSize: 20,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  List<MapEntry<String, DayPlan>> _sortWeekEntries(
    List<MapEntry<String, DayPlan>> entries,
  ) {
    const order = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    int indexOf(String day) {
      final i = order.indexWhere((d) => d.toLowerCase() == day.toLowerCase());
      return i == -1 ? 999 : i;
    }

    entries.sort((a, b) => indexOf(a.key).compareTo(indexOf(b.key)));
    return entries;
  }
}
