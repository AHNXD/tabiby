class SymptomQuestion {
  final String id;
  final String labelAr;
  final String type;
  final List<String> options;
  final double min;
  final double max;
  final dynamic answer;

  const SymptomQuestion({
    required this.id,
    required this.labelAr,
    required this.type,
    this.options = const [],
    this.min = 1,
    this.max = 10,
    this.answer,
  });

  factory SymptomQuestion.fromJson(Map<String, dynamic> json) {
    final List<String> parsedOptions = [];
    final dynamic rawOptions = json['options_ar'] ?? json['options'];

    if (rawOptions is List) {
      for (final dynamic item in rawOptions) {
        if (item is String) {
          parsedOptions.add(item);
        } else if (item is Map && item['label'] != null) {
          parsedOptions.add(item['label'].toString());
        }
      }
    }

    return SymptomQuestion(
      id: json['id']?.toString() ?? 'unknown_q',
      labelAr:
          json['label_ar']?.toString() ?? json['text']?.toString() ?? 'سؤال',
      type: json['type']?.toString() ?? 'dropdown',
      options: parsedOptions,
      min: (json['min'] as num?)?.toDouble() ?? 1,
      max: (json['max'] as num?)?.toDouble() ?? 10,
    );
  }

  SymptomQuestion copyWith({dynamic answer}) {
    return SymptomQuestion(
      id: id,
      labelAr: labelAr,
      type: type,
      options: options,
      min: min,
      max: max,
      answer: answer,
    );
  }

  bool get hasAnswer {
    if (answer == null) {
      return false;
    }
    if (answer is String && (answer as String).trim().isEmpty) {
      return false;
    }
    return true;
  }
}

class Symptom {
  final String id;
  final String labelAr;
  final String labelEn;
  final List<SymptomQuestion> questions;
  final bool isSelected;

  const Symptom({
    required this.id,
    required this.labelAr,
    required this.labelEn,
    required this.questions,
    this.isSelected = false,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id']?.toString() ?? 'unknown',
      labelAr:
          json['label_ar']?.toString() ?? json['name']?.toString() ?? 'عرض',
      labelEn: json['label_en']?.toString() ?? '',
      questions: (json['follow_up_questions'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (dynamic q) =>
                SymptomQuestion.fromJson(Map<String, dynamic>.from(q as Map)),
          )
          .toList(),
    );
  }

  Symptom copyWith({List<SymptomQuestion>? questions, bool? isSelected}) {
    return Symptom(
      id: id,
      labelAr: labelAr,
      labelEn: labelEn,
      questions: questions ?? this.questions,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toSelectedPayload() {
    final Map<String, dynamic> answersMap = {};
    for (final SymptomQuestion question in questions) {
      if (question.hasAnswer) {
        answersMap[question.id] = question.answer;
      }
    }

    return {'id': id, 'label_ar': labelAr, 'answers': answersMap};
  }
}
