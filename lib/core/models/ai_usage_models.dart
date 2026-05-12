class AiJsonParsing {
  static int readInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static String readString(dynamic value, {String fallback = ''}) {
    if (value is String) return value;
    if (value == null) return fallback;
    return value.toString();
  }

  static DateTime? readDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static Map<String, dynamic> readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return const <String, dynamic>{};
  }
}

enum AiFeatureType { diagnosis, xrayAnalysis, programDiet }

extension AiFeatureTypeX on AiFeatureType {
  String get apiValue {
    switch (this) {
      case AiFeatureType.diagnosis:
        return 'diagnosis';
      case AiFeatureType.xrayAnalysis:
        return 'xray_analysis';
      case AiFeatureType.programDiet:
        return 'program_diet';
    }
  }

  static AiFeatureType? fromApiValue(String? value) {
    switch (value) {
      case 'diagnosis':
        return AiFeatureType.diagnosis;
      case 'xray_analysis':
        return AiFeatureType.xrayAnalysis;
      case 'program_diet':
        return AiFeatureType.programDiet;
    }
    return null;
  }
}

class AiFeatureUsageLimit {
  final int limit;
  final int used;
  final int remaining;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const AiFeatureUsageLimit({
    required this.limit,
    required this.used,
    required this.remaining,
    this.periodStart,
    this.periodEnd,
  });

  factory AiFeatureUsageLimit.fromJson(Map<String, dynamic> json) {
    return AiFeatureUsageLimit(
      limit: AiJsonParsing.readInt(json['limit']),
      used: AiJsonParsing.readInt(json['used']),
      remaining: AiJsonParsing.readInt(json['remaining']),
      periodStart: AiJsonParsing.readDateTime(json['period_start']),
      periodEnd: AiJsonParsing.readDateTime(json['period_end']),
    );
  }
}

class AiRemainingUsageResponse {
  final String message;
  final int status;
  final Map<AiFeatureType, AiFeatureUsageLimit> remainingByFeature;

  const AiRemainingUsageResponse({
    required this.message,
    required this.status,
    required this.remainingByFeature,
  });

  AiFeatureUsageLimit? usageFor(AiFeatureType type) => remainingByFeature[type];

  factory AiRemainingUsageResponse.fromJson(Map<String, dynamic> json) {
    final remainingRaw = AiJsonParsing.readMap(json['remaining']);

    final Map<AiFeatureType, AiFeatureUsageLimit> parsed = {};
    for (final entry in remainingRaw.entries) {
      final featureType = AiFeatureTypeX.fromApiValue(entry.key);
      if (featureType == null) continue;
      final Map<String, dynamic> limitJson = AiJsonParsing.readMap(entry.value);
      parsed[featureType] = AiFeatureUsageLimit.fromJson(limitJson);
    }

    return AiRemainingUsageResponse(
      message: AiJsonParsing.readString(json['message']),
      status: AiJsonParsing.readInt(json['status']),
      remainingByFeature: Map.unmodifiable(parsed),
    );
  }
}
