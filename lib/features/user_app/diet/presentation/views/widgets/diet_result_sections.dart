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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 14),
            Text(text, textAlign: TextAlign.center),
          ],
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class DietInfoCard extends StatelessWidget {
  const DietInfoCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxStyle(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColors,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.all(14),
      decoration: _boxStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diet_result_daily_macros'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('${'diet_result_protein'.tr(context)}: ${macros.protein}'),
          Text('${'diet_result_carbs'.tr(context)}: ${macros.carbs}'),
          Text('${'diet_result_fats'.tr(context)}: ${macros.fats}'),
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
      padding: const EdgeInsets.all(14),
      decoration: _boxStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diet_result_clinical_summary'.tr(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            summary,
            style: TextStyle(color: Colors.grey.shade800, height: 1.5),
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
      decoration: _boxStyle(),
      child: ExpansionTile(
        title: Text(
          'diet_result_input_values_used'.tr(context),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: map.entries
            .where(
              (entry) =>
                  entry.value != null &&
                  entry.value.toString().trim().isNotEmpty,
            )
            .map((entry) => _RequestValueRow(entry: entry))
            .toList(),
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
                color: Colors.grey.shade700,
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _boxStyle(radius: 12),
      child: ExpansionTile(
        title: Text(
          _localizedDay(context, day),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${'diet_result_daily_advice'.tr(context)}: ${plan.dailyAdvice}',
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
        ],
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
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ${meal!.meal}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${'diet_result_calories_short'.tr(context)}: ${meal!.calories} | '
            '${'diet_result_protein_short'.tr(context)}: ${meal!.proteinG}g | '
            '${'diet_result_carbs_short'.tr(context)}: ${meal!.carbsG}g | '
            '${'diet_result_fats_short'.tr(context)}: ${meal!.fatsG}g',
          ),
          if (meal!.ingredients.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${'diet_result_ingredients'.tr(context)}: ${meal!.ingredients.join(', ')}',
            ),
          ],
          if (meal!.preparationTip.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('${'diet_result_tip'.tr(context)}: ${meal!.preparationTip}'),
          ],
        ],
      ),
    );
  }
}

BoxDecoration _boxStyle({double radius = 14}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.grey.shade200),
  );
}
