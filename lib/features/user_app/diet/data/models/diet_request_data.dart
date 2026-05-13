class DietRequestData {
  const DietRequestData({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.jobNature,
    required this.goal,
    required this.chronicDiseases,
    required this.medications,
    required this.allergies,
    this.favoriteFoods,
    this.dislikedFoods,
    required this.digestionIssues,
    required this.mealsPerDay,
    required this.sweetsFrequency,
    required this.sodaFrequency,
    required this.eatingOutFrequency,
    required this.exercise,
    required this.sleepHours,
    required this.insomnia,
    required this.emotionalEating,
    required this.eatingSpeed,
    required this.isSpecialist,
    this.dietType,
    this.macroDistribution,
    this.specialistNotes,
  });

  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String jobNature;
  final String goal;
  final String chronicDiseases;
  final String medications;
  final String allergies;
  final String? favoriteFoods;
  final String? dislikedFoods;
  final String digestionIssues;
  final int mealsPerDay;
  final String sweetsFrequency;
  final String sodaFrequency;
  final String eatingOutFrequency;
  final String exercise;
  final double sleepHours;
  final String insomnia;
  final String emotionalEating;
  final String eatingSpeed;
  final bool isSpecialist;
  final String? dietType;
  final String? macroDistribution;
  final String? specialistNotes;

  factory DietRequestData.fromJson(Map<String, dynamic> json) {
    return DietRequestData(
      name: (json['name'] ?? '').toString(),
      age: _toInt(json['age'], 30),
      gender: (json['gender'] ?? '').toString(),
      height: _toDouble(json['height'], 170),
      weight: _toDouble(json['weight'], 75),
      jobNature: (json['job_nature'] ?? '').toString(),
      goal: (json['goal'] ?? '').toString(),
      chronicDiseases: (json['chronic_diseases'] ?? '').toString(),
      medications: (json['medications'] ?? '').toString(),
      allergies: (json['allergies'] ?? '').toString(),
      favoriteFoods: json['favorite_foods']?.toString(),
      dislikedFoods: json['disliked_foods']?.toString(),
      digestionIssues: (json['digestion_issues'] ?? '').toString(),
      mealsPerDay: _toInt(json['meals_per_day'], 3),
      sweetsFrequency: (json['sweets_frequency'] ?? '').toString(),
      sodaFrequency: (json['soda_frequency'] ?? '').toString(),
      eatingOutFrequency: (json['eating_out_frequency'] ?? '').toString(),
      exercise: (json['exercise'] ?? '').toString(),
      sleepHours: _toDouble(json['sleep_hours'], 7),
      insomnia: (json['insomnia'] ?? '').toString(),
      emotionalEating: (json['emotional_eating'] ?? '').toString(),
      eatingSpeed: (json['eating_speed'] ?? '').toString(),
      isSpecialist: json['is_specialist'] == true || json['diet_type'] != null,
      dietType: json['diet_type']?.toString(),
      macroDistribution: json['macro_distribution']?.toString(),
      specialistNotes: json['specialist_notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'job_nature': jobNature,
      'goal': goal,
      'chronic_diseases': chronicDiseases,
      'medications': medications,
      'allergies': allergies,
      'favorite_foods': favoriteFoods ?? '',
      'disliked_foods': dislikedFoods ?? '',
      'digestion_issues': digestionIssues,
      'meals_per_day': mealsPerDay,
      'sweets_frequency': sweetsFrequency,
      'soda_frequency': sodaFrequency,
      'eating_out_frequency': eatingOutFrequency,
      'exercise': exercise,
      'sleep_hours': sleepHours,
      'insomnia': insomnia,
      'emotional_eating': emotionalEating,
      'eating_speed': eatingSpeed,
      'is_specialist': isSpecialist,
    };

    if (isSpecialist) {
      map['diet_type'] = dietType ?? '';
      map['macro_distribution'] = macroDistribution ?? '';
      map['specialist_notes'] = specialistNotes ?? '';
    }

    return map;
  }
}

int _toInt(dynamic value, int fallback) {
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _toDouble(dynamic value, double fallback) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}
