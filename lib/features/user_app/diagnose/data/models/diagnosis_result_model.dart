class DiagnosisResult {
  final String urgency;
  final bool isEmergency;
  final String conditionName;
  final String confidence;
  final String specialist;
  final String reasoning;
  final List<String> adviceSteps;

  const DiagnosisResult({
    required this.urgency,
    required this.isEmergency,
    required this.conditionName,
    required this.confidence,
    required this.specialist,
    required this.reasoning,
    required this.adviceSteps,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      urgency: json['urgency']?.toString() ?? 'Low',
      isEmergency: json['emergency_warning'] == true,
      conditionName:
          json['primary_condition_suspicion']?.toString() ?? 'غير محدد',
      confidence: json['confidence_score']?.toString() ?? '0%',
      specialist: json['recommended_specialist_ar']?.toString() ?? 'طبيب عام',
      reasoning: json['reasoning_ar']?.toString() ?? 'لا يوجد تفاصيل إضافية.',
      adviceSteps: (json['next_steps_advice'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  String get confidenceWithoutPercent => confidence.replaceAll('%', '').trim();
}
