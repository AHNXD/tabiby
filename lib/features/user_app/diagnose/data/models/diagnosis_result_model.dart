class DiagnosisResult {
  final bool success;
  final String? message; // For errors
  final ResultData? result;

  DiagnosisResult({required this.success, this.message, this.result});

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      success: json['success'],
      message: json['message'],
      result: json['result'] != null
          ? ResultData.fromJson(json['result'])
          : null,
    );
  }
}

class ResultData {
  final String name;
  final String specialty;
  final bool emergency;
  final double confidence;

  ResultData({
    required this.name,
    required this.specialty,
    required this.emergency,
    required this.confidence,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      name: json['name'],
      specialty: json['specialty'],
      emergency: json['emergency'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}
