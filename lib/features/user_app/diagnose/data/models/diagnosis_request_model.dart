import 'dart:convert';

class DiagnosisRequest {
  final String lang;
  final int categoryId;
  final Map<String, int> responses; // {"1": 1, "2": 0}

  DiagnosisRequest({
    required this.lang,
    required this.categoryId,
    required this.responses,
  });

  String toJson() => json.encode({
    'lang': lang,
    'category_id': categoryId,
    'responses': responses,
  });
}
