class DiagnosisRequest {
  final List<Map<String, dynamic>> selectedSymptoms;

  const DiagnosisRequest({required this.selectedSymptoms});

  Map<String, dynamic> toJson() {
    return {'selected_symptoms': selectedSymptoms};
  }
}
