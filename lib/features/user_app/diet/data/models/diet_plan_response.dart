class DietPlanResponse {
  const DietPlanResponse({
    required this.summaryAr,
    required this.dietTypeApplied,
    required this.dailyCaloriesTarget,
    required this.dailyMacrosSummary,
    required this.weekPlan,
  });

  final String summaryAr;
  final String dietTypeApplied;
  final int dailyCaloriesTarget;
  final Macros dailyMacrosSummary;
  final Map<String, DayPlan> weekPlan;

  factory DietPlanResponse.fromJson(Map<String, dynamic> json) {
    final rawWeek = json['week_plan'] as Map<String, dynamic>? ?? {};
    final week = <String, DayPlan>{};
    rawWeek.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        week[key] = DayPlan.fromJson(value);
      }
    });

    return DietPlanResponse(
      summaryAr: (json['summary_ar'] ?? '').toString(),
      dietTypeApplied: (json['diet_type_applied'] ?? '').toString(),
      dailyCaloriesTarget: _toInt(json['daily_calories_target']),
      dailyMacrosSummary: Macros.fromJson(
        json['daily_macros_summary'] as Map<String, dynamic>? ?? {},
      ),
      weekPlan: week,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary_ar': summaryAr,
      'diet_type_applied': dietTypeApplied,
      'daily_calories_target': dailyCaloriesTarget,
      'daily_macros_summary': dailyMacrosSummary.toJson(),
      'week_plan': weekPlan.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class DayPlan {
  const DayPlan({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    required this.dailyAdvice,
  });

  final MealDetails? breakfast;
  final MealDetails? lunch;
  final MealDetails? dinner;
  final MealDetails? snack;
  final String dailyAdvice;

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    MealDetails? toMeal(dynamic value) {
      if (value is Map<String, dynamic>) {
        return MealDetails.fromJson(value);
      }
      return null;
    }

    return DayPlan(
      breakfast: toMeal(json['breakfast']),
      lunch: toMeal(json['lunch']),
      dinner: toMeal(json['dinner']),
      snack: toMeal(json['snack']),
      dailyAdvice: (json['daily_advice'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.toJson(),
      'lunch': lunch?.toJson(),
      'dinner': dinner?.toJson(),
      'snack': snack?.toJson(),
      'daily_advice': dailyAdvice,
    };
  }
}

class MealDetails {
  const MealDetails({
    required this.meal,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.ingredients,
    required this.preparationTip,
  });

  final String meal;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final List<String> ingredients;
  final String preparationTip;

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    return MealDetails(
      meal: (json['meal'] ?? '').toString(),
      calories: _toInt(json['calories']),
      proteinG: _toInt(json['protein_g']),
      carbsG: _toInt(json['carbs_g']),
      fatsG: _toInt(json['fats_g']),
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      preparationTip: (json['preparation_tip'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal': meal,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fats_g': fatsG,
      'ingredients': ingredients,
      'preparation_tip': preparationTip,
    };
  }
}

class Macros {
  const Macros({
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  final String protein;
  final String carbs;
  final String fats;

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      protein: (json['protein'] ?? '').toString(),
      carbs: (json['carbs'] ?? '').toString(),
      fats: (json['fats'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'protein': protein, 'carbs': carbs, 'fats': fats};
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
