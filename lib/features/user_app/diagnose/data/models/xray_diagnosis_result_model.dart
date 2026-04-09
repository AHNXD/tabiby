import 'package:equatable/equatable.dart';

class XrayDiagnosisResult extends Equatable {
  const XrayDiagnosisResult({
    required this.aiDiagnosis,
    required this.findings,
    required this.topDisease,
    required this.topProbability,
    this.heatmapUrl,
  });

  final String aiDiagnosis;
  final Map<String, double> findings;
  final String topDisease;
  final double topProbability;
  final String? heatmapUrl;

  factory XrayDiagnosisResult.fromJson(Map<String, dynamic> json) {
    final Map<String, double> parsedFindings = _parseFindings(
      json['top_3_diseases'],
    );
    final MapEntry<String, double>? bestFinding = parsedFindings.entries.isEmpty
        ? null
        : (parsedFindings.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first;

    final String parsedTopDisease =
        json['top_disease']?.toString().trim().isNotEmpty == true
        ? json['top_disease'].toString()
        : bestFinding?.key ?? 'Unknown';

    final double parsedTopProbability = _normalizeProbability(
      json['top_probability'],
    );

    return XrayDiagnosisResult(
      aiDiagnosis: json['ai_diagnosis']?.toString().trim().isNotEmpty == true
          ? json['ai_diagnosis'].toString()
          : 'No diagnosis was generated',
      findings: parsedFindings,
      topDisease: parsedTopDisease,
      topProbability: parsedTopProbability > 0
          ? parsedTopProbability
          : bestFinding?.value ?? 0,
      heatmapUrl: json['heatmap_url']?.toString(),
    );
  }

  List<MapEntry<String, double>> get sortedFindings {
    final List<MapEntry<String, double>> items = findings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return items;
  }

  bool get hasHeatmap => heatmapUrl?.trim().isNotEmpty == true;

  static Map<String, double> _parseFindings(dynamic rawFindings) {
    if (rawFindings is! Map) {
      return const <String, double>{};
    }

    final Map<String, double> parsed = <String, double>{};

    for (final MapEntry<dynamic, dynamic> entry in rawFindings.entries) {
      final String key = entry.key?.toString().trim() ?? '';
      if (key.isEmpty) {
        continue;
      }

      parsed[key] = _normalizeProbability(entry.value);
    }

    return parsed;
  }

  static double _normalizeProbability(dynamic value) {
    final double? parsedValue = switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text),
      _ => null,
    };

    if (parsedValue == null || parsedValue <= 0) {
      return 0;
    }

    final double normalized = parsedValue > 1 ? parsedValue / 100 : parsedValue;

    return normalized.clamp(0, 1).toDouble();
  }

  @override
  List<Object?> get props => [
    aiDiagnosis,
    findings,
    topDisease,
    topProbability,
    heatmapUrl,
  ];
}
