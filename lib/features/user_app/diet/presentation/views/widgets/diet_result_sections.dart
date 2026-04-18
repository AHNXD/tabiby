import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_plan_response.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_request_data.dart';

class DietLoadingOnlyView extends StatelessWidget {
  const DietLoadingOnlyView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: _boxStyle(radius: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  color: AppColors.primaryColors,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 14),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grey800Color,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DietNoticeBanner extends StatelessWidget {
  const DietNoticeBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blueColor.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blueColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.info_outline, color: AppColors.blueColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.grey800Color,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DietOverviewCard extends StatelessWidget {
  const DietOverviewCard({
    super.key,
    required this.title,
    required this.calories,
    this.waterLiters,
  });

  final String title;
  final int calories;
  final double? waterLiters;

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
            bottom: 36,
            child: Container(
              width: 130,
              height: 130,
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
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        color: AppColors.primaryColors,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.16,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_outlined,
                            color: AppColors.primaryColors,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            calories.toString(),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _DietSummaryStat(
                          icon: Icons.local_fire_department_outlined,
                          label: 'diet_result_daily_calories'.tr(context),
                          value: calories.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DietSummaryStat(
                          icon: Icons.water_drop_outlined,
                          label: 'diet_result_daily_water'.tr(context),
                          value: waterLiters?.toString() ?? '--',
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
}

class DietMacrosCard extends StatelessWidget {
  const DietMacrosCard({super.key, required this.macros});

  final Macros macros;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _boxStyle(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diet_result_daily_macros'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MacroTile(
                  label: 'diet_result_protein'.tr(context),
                  value: macros.protein,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MacroTile(
                  label: 'diet_result_carbs'.tr(context),
                  value: macros.carbs,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MacroTile(
                  label: 'diet_result_fats'.tr(context),
                  value: macros.fats,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DietSummaryCard extends StatelessWidget {
  const DietSummaryCard({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _boxStyle(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diet_result_clinical_summary'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.paleSuccessSurfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColors.withValues(alpha: 0.12),
              ),
            ),
            child: Text(
              summary,
              style: TextStyle(color: AppColors.grey800Color, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class DietRequestValuesCard extends StatelessWidget {
  const DietRequestValuesCard({super.key, required this.request});

  final DietRequestData request;

  static const Map<String, String> _fieldKeyMap = {
    'name': 'diet_form_name',
    'age': 'diet_form_age',
    'gender': 'diet_form_gender',
    'height': 'diet_form_height_cm',
    'weight': 'diet_form_weight_kg',
    'job_nature': 'diet_form_job_nature',
    'goal': 'diet_form_goal',
    'chronic_diseases': 'diet_form_chronic_diseases',
    'medications': 'diet_form_medications',
    'allergies': 'diet_form_allergies',
    'digestion_issues': 'diet_form_digestion_issues',
    'meals_per_day': 'diet_form_meals_per_day',
    'sweets_frequency': 'diet_form_sweets_frequency',
    'soda_frequency': 'diet_form_soda_frequency',
    'eating_out_frequency': 'diet_form_eating_out_frequency',
    'exercise': 'diet_form_exercise',
    'sleep_hours': 'diet_form_sleep_hours',
    'insomnia': 'diet_form_insomnia',
    'emotional_eating': 'diet_form_emotional_eating',
    'eating_speed': 'diet_form_eating_speed',
    'is_specialist': 'diet_form_is_specialist',
    'diet_type': 'diet_form_diet_type',
    'macro_distribution': 'diet_form_macro_distribution',
    'specialist_notes': 'diet_form_specialist_notes',
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> map = request.toJson();

    return Container(
      decoration: _boxStyle(radius: 22),
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(dividerColor: AppColors.transparentColor),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          title: Text(
            'diet_result_input_values_used'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          children: map.entries
              .where(
                (entry) =>
                    entry.value != null &&
                    entry.value.toString().trim().isNotEmpty,
              )
              .map((entry) => _RequestValueRow(entry: entry))
              .toList(),
        ),
      ),
    );
  }
}

class _RequestValueRow extends StatelessWidget {
  const _RequestValueRow({required this.entry});

  final MapEntry<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final labelKey = DietRequestValuesCard._fieldKeyMap[entry.key];
    final label = labelKey?.tr(context) ?? entry.key;

    String value = entry.value.toString();
    if (entry.key == 'is_specialist') {
      value = entry.value == true ? 'yes'.tr(context) : 'no'.tr(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey700Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}

class DietDayPlanTile extends StatelessWidget {
  const DietDayPlanTile({super.key, required this.day, required this.plan});

  final String day;
  final DayPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: _boxStyle(radius: 22),
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(dividerColor: AppColors.transparentColor),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _localizedDay(context, day).substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.primaryColors,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _localizedDay(context, day),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            DietMealCard(
              title: 'diet_result_meal_breakfast'.tr(context),
              meal: plan.breakfast,
            ),
            DietMealCard(
              title: 'diet_result_meal_lunch'.tr(context),
              meal: plan.lunch,
            ),
            DietMealCard(
              title: 'diet_result_meal_dinner'.tr(context),
              meal: plan.dinner,
            ),
            DietMealCard(
              title: 'diet_result_meal_snack'.tr(context),
              meal: plan.snack,
            ),
            if (plan.dailyAdvice.trim().isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.tips_and_updates_outlined,
                      color: AppColors.primaryColors,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${'diet_result_daily_advice'.tr(context)}: ${plan.dailyAdvice}',
                        style: TextStyle(
                          color: AppColors.grey800Color,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _localizedDay(BuildContext context, String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 'saturday'.tr(context);
      case 'sunday':
        return 'sunday'.tr(context);
      case 'monday':
        return 'monday'.tr(context);
      case 'tuesday':
        return 'tuesday'.tr(context);
      case 'wednesday':
        return 'wednesday'.tr(context);
      case 'thursday':
        return 'thursday'.tr(context);
      case 'friday':
        return 'friday'.tr(context);
      default:
        return day;
    }
  }
}

class DietMealCard extends StatelessWidget {
  const DietMealCard({super.key, required this.title, required this.meal});

  final String title;
  final MealDetails? meal;

  @override
  Widget build(BuildContext context) {
    if (meal == null || meal!.meal.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softNeutralSurfaceAltColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  meal!.meal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(
                label:
                    '${'diet_result_calories_short'.tr(context)} ${meal!.calories}',
              ),
              _MetricChip(
                label:
                    '${'diet_result_protein_short'.tr(context)} ${meal!.proteinG}g',
              ),
              _MetricChip(
                label:
                    '${'diet_result_carbs_short'.tr(context)} ${meal!.carbsG}g',
              ),
              _MetricChip(
                label:
                    '${'diet_result_fats_short'.tr(context)} ${meal!.fatsG}g',
              ),
            ],
          ),
          if (meal!.ingredients.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'diet_result_ingredients'.tr(context),
              style: TextStyle(
                color: AppColors.grey800Color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...meal!.ingredients.map(
              (ingredient) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColors,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ingredient,
                        style: TextStyle(
                          color: AppColors.grey700Color,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (meal!.preparationTip.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColors.withValues(alpha: 0.12),
                ),
              ),
              child: Text(
                '${'diet_result_tip'.tr(context)}: ${meal!.preparationTip}',
                style: TextStyle(color: AppColors.grey800Color, height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

BoxDecoration _boxStyle({double radius = 14}) {
  return BoxDecoration(
    color: AppColors.whiteColor,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.grey200Color),
    boxShadow: [
      BoxShadow(
        color: AppColors.blackColor.withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

class _DietSummaryStat extends StatelessWidget {
  const _DietSummaryStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColors, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.grey600Color, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.paleSuccessSurfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryColors,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey700Color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.grey800Color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
