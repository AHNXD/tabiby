class DietPlanResponse {
  const DietPlanResponse({
    required this.summary,
    required this.dietTypeApplied,
    required this.dailyCaloriesTarget,
    this.dailyWaterLiters,
    required this.dailyMacrosSummary,
    required this.weekPlan,
  });

  final String summary;
  final String dietTypeApplied;
  final int dailyCaloriesTarget;
  final double? dailyWaterLiters;
  final Macros dailyMacrosSummary;
  final Map<String, DayPlan> weekPlan;

  String get localizedSummary => summary.trim().isNotEmpty ? summary : '';

  factory DietPlanResponse.fromJson(Map<String, dynamic> json) {
    final rawWeek = _mapOf(json['week_plan']);
    final week = <String, DayPlan>{};
    rawWeek.forEach((key, value) {
      if (value is Map) {
        week[key] = DayPlan.fromJson(Map<String, dynamic>.from(value));
      }
    });

    final String summary = (json['summary'] ?? '').toString();

    return DietPlanResponse(
      summary: summary,
      dietTypeApplied: (json['diet_type_applied'] ?? '').toString(),
      dailyCaloriesTarget: _toInt(json['daily_calories_target']),
      dailyWaterLiters: _toDoubleOrNull(json['daily_water_liters']),
      dailyMacrosSummary: Macros.fromJson(_mapOf(json['daily_macros_summary'])),
      weekPlan: week,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'summary': summary,
      'diet_type_applied': dietTypeApplied,
      'daily_calories_target': dailyCaloriesTarget,
      'daily_macros_summary': dailyMacrosSummary.toJson(),
      'week_plan': weekPlan.map((key, value) => MapEntry(key, value.toJson())),
    };

    if (dailyWaterLiters != null) {
      map['daily_water_liters'] = dailyWaterLiters;
    }

    return map;
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
      if (value is Map) {
        return MealDetails.fromJson(Map<String, dynamic>.from(value));
      }
      if (value is String && value.trim().isNotEmpty) {
        return MealDetails(
          meal: value.trim(),
          calories: 0,
          proteinG: 0,
          carbsG: 0,
          fatsG: 0,
          ingredients: const [],
          preparationTip: value.trim(),
        );
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
    final List<Map<String, dynamic>> itemMaps = _mapListOf(
      json['items'] ?? json['foods'],
    );
    final List<String> itemStrings = _stringListFromDynamic(
      json['items'] ?? json['foods'],
    );

    final String mealTitle = _firstNonEmptyString(json, const [
      'meal',
      'meal_name',
      'title',
      'name',
      'dish_name',
      'dish',
      'item',
      'description',
    ]);

    final String preparationTip = _firstNonEmptyString(json, const [
      'preparation_tip',
      'instructions',
      'tip',
      'notes',
      'method',
      'description',
    ]);

    return MealDetails(
      meal: mealTitle.isNotEmpty
          ? mealTitle
          : _firstNonEmptyStringFromMaps(itemMaps, const ['name', 'title']),
      calories: _firstInt(json, const [
        'total_calories',
        'calories',
        'calories_kcal',
        'kcal',
        'energy',
        'energy_kcal',
      ], fallbackMaps: itemMaps),
      proteinG: _firstInt(json, const [
        'total_protein_g',
        'protein_g',
        'protein',
        'proteinGrams',
        'protein_grams',
      ], fallbackMaps: itemMaps),
      carbsG: _firstInt(json, const [
        'total_carbs_g',
        'carbs_g',
        'carbs',
        'carbohydrates_g',
        'carbohydrates',
      ], fallbackMaps: itemMaps),
      fatsG: _firstInt(json, const [
        'total_fats_g',
        'fats_g',
        'fat_g',
        'fats',
        'fat',
      ], fallbackMaps: itemMaps),
      ingredients: _ingredientsFromMealJson(
        json,
        itemMaps: itemMaps,
        itemStrings: itemStrings,
      ),
      preparationTip: preparationTip,
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
      protein: _macroValue(json['protein'] ?? json['protein_g']),
      carbs: _macroValue(json['carbs'] ?? json['carbs_g']),
      fats: _macroValue(json['fats'] ?? json['fats_g']),
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

double? _toDoubleOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  return double.tryParse(value.toString());
}

Map<String, dynamic> _mapOf(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const <String, dynamic>{};
}

String _macroValue(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is num) {
    final normalized = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    return '${normalized}g';
  }

  final text = value.toString().trim();
  if (text.isEmpty) {
    return '';
  }

  return text.toLowerCase().endsWith('g') ? text : '${text}g';
}

String _firstNonEmptyString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) {
      continue;
    }

    final text = value.toString().trim();
    if (text.isNotEmpty && text.toLowerCase() != 'null') {
      return text;
    }
  }

  return '';
}

int _firstInt(
  Map<String, dynamic> json,
  List<String> keys, {
  List<Map<String, dynamic>> fallbackMaps = const [],
}) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) {
      continue;
    }

    final parsed = _toIntFlexible(value);
    if (parsed != null) {
      return parsed;
    }
  }

  if (fallbackMaps.isNotEmpty) {
    final summed = _sumFromMaps(
      fallbackMaps,
      keys.where((key) => !key.startsWith('total_')).toList(),
    );
    if (summed != null) {
      return summed;
    }
  }

  return 0;
}

int? _toIntFlexible(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.round();
  }
  if (value is String) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.\\-]'), '').trim();
    if (cleaned.isEmpty) {
      return null;
    }

    final parsedDouble = double.tryParse(cleaned);
    if (parsedDouble != null) {
      return parsedDouble.round();
    }
  }

  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is List) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty && item.toLowerCase() != 'null')
        .toList();
  }

  if (value is String) {
    return value
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return const [];
}

List<Map<String, dynamic>> _mapListOf(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  return const [];
}

String _firstNonEmptyStringFromMaps(
  List<Map<String, dynamic>> items,
  List<String> keys,
) {
  for (final item in items) {
    final text = _firstNonEmptyString(item, keys);
    if (text.isNotEmpty) {
      return text;
    }
  }

  return '';
}

int? _sumFromMaps(List<Map<String, dynamic>> items, List<String> keys) {
  double total = 0;
  bool foundAny = false;

  for (final item in items) {
    for (final key in keys) {
      final parsed = _toIntFlexible(item[key]);
      if (parsed != null) {
        total += parsed;
        foundAny = true;
        break;
      }
    }
  }

  if (!foundAny) {
    return null;
  }

  return total.round();
}

List<String> _ingredientsFromMealJson(
  Map<String, dynamic> json, {
  required List<Map<String, dynamic>> itemMaps,
  required List<String> itemStrings,
}) {
  if (itemMaps.isNotEmpty) {
    return itemMaps
        .map((item) {
          final name = _firstNonEmptyString(item, const [
            'name',
            'title',
            'meal',
          ]);
          final quantity = _firstNonEmptyString(item, const [
            'quantity',
            'amount',
          ]);

          if (name.isEmpty) {
            return quantity;
          }
          if (quantity.isEmpty) {
            return name;
          }
          return '$name: $quantity';
        })
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  if (itemStrings.isNotEmpty) {
    return itemStrings;
  }

  return _stringListFromDynamic(
    json['ingredients'] ?? json['ingredient_list'] ?? json['components'],
  );
}
