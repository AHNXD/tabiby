import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';

import '../../../../../core/Api_services/ai_proxy_service.dart';
import '../../../../../core/errors/ai_exception.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/diagnosis_request_model.dart';
import '../models/diagnosis_result_model.dart';
import '../models/symptom_model.dart';
import '../models/xray_diagnosis_result_model.dart';

class DiagnosisRepositoryIplm implements DiagnosisRepository {
  final AiProxyService _aiProxyService;

  DiagnosisRepositoryIplm(this._aiProxyService);

  @override
  Future<Either<Failure, List<Symptom>>> getSymptoms(String bodyPart) async {
    try {
      final response = await _aiProxyService.getSymptoms({
        'body_part': bodyPart,
      });

      final dynamic normalized = _normalizeAiBody(response);
      final List<dynamic> rawSymptoms = _extractSymptomsList(normalized);
      final List<Symptom> symptoms = rawSymptoms
          .whereType<Map>()
          .map(
            (dynamic item) =>
                Symptom.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      return right(symptoms);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, DiagnosisResult>> postDiagnosis(
    DiagnosisRequest request,
  ) async {
    try {
      final response = await _aiProxyService.diagnose(request.toJson());

      final dynamic normalized = _normalizeAiBody(response);

      if (normalized is Map && normalized['error'] != null) {
        return left(const ServerFailure(AiException.serviceUnavailable));
      }

      final Map<String, dynamic>? triageResult = _extractTriageResultMap(
        normalized,
      );

      if (triageResult == null) {
        return left(const ServerFailure(AiException.serviceUnavailable));
      }

      return right(DiagnosisResult.fromJson(triageResult));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, XrayDiagnosisResult>> analyzeChestXray(
    String imagePath,
  ) async {
    try {
      final file = File(imagePath);
      final fileName = imagePath.split(Platform.pathSeparator).last;
      final response = await _aiProxyService.analyzeXray({
        'image': base64Encode(await file.readAsBytes()),
        'file_name': fileName,
      });

      final dynamic normalized = _normalizeAiBody(response);

      if (normalized is Map && normalized['error'] != null) {
        return left(const ServerFailure(AiException.serviceUnavailable));
      }

      final Map<String, dynamic>? imageDiagnosisMap = _extractImageDiagnosisMap(
        normalized,
      );

      if (imageDiagnosisMap == null) {
        return left(const ServerFailure(AiException.serviceUnavailable));
      }

      return right(XrayDiagnosisResult.fromJson(imageDiagnosisMap));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  List<dynamic> _extractSymptomsList(dynamic source) {
    if (source is Map<String, dynamic>) {
      if (source['symptoms'] is List) {
        return source['symptoms'] as List<dynamic>;
      }
      final dynamic nestedData = source['data'];
      if (nestedData is Map<String, dynamic>) {
        return _extractSymptomsList(nestedData);
      }
    }

    if (source is List) {
      if (source.isNotEmpty && source.first is Map) {
        final Map<String, dynamic> firstItem = Map<String, dynamic>.from(
          source.first as Map,
        );
        if (firstItem['symptoms'] is List) {
          return firstItem['symptoms'] as List<dynamic>;
        }
      }
      return source;
    }

    return const [];
  }

  Map<String, dynamic>? _extractTriageResultMap(dynamic source) {
    if (source is Map<String, dynamic>) {
      if (source['triage_result'] is Map) {
        return Map<String, dynamic>.from(source['triage_result'] as Map);
      }

      if (_looksLikeTriageResult(source)) {
        return source;
      }

      if (source['data'] is Map<String, dynamic>) {
        return _extractTriageResultMap(source['data']);
      }

      if (source['output'] != null) {
        return _extractTriageResultMap(source['output']);
      }
    }

    if (source is List && source.isNotEmpty) {
      return _extractTriageResultMap(source.first);
    }

    return null;
  }

  Map<String, dynamic>? _extractImageDiagnosisMap(dynamic source) {
    if (source is Map<String, dynamic>) {
      if (_looksLikeImageDiagnosisResult(source)) {
        return source;
      }

      if (source['data'] is Map<String, dynamic>) {
        return _extractImageDiagnosisMap(source['data']);
      }

      if (source['result'] != null) {
        return _extractImageDiagnosisMap(source['result']);
      }

      if (source['output'] != null) {
        return _extractImageDiagnosisMap(source['output']);
      }
    }

    if (source is List && source.isNotEmpty) {
      return _extractImageDiagnosisMap(source.first);
    }

    return null;
  }

  bool _looksLikeTriageResult(Map<String, dynamic> json) {
    return json.containsKey('urgency') ||
        json.containsKey('emergency_warning') ||
        json.containsKey('primary_condition_suspicion');
  }

  bool _looksLikeImageDiagnosisResult(Map<String, dynamic> json) {
    return json.containsKey('top_3_diseases') ||
        json.containsKey('ai_diagnosis') ||
        json.containsKey('heatmap_url');
  }

  dynamic _normalizeAiBody(dynamic source) {
    dynamic current = source;

    if (current is List && current.isNotEmpty) {
      current = current.first;
    }

    if (current is Map && current['output'] != null) {
      current = current['output'];
    }

    if (current is String) {
      final dynamic decoded = _decodeJsonString(current);
      if (decoded != null) {
        return _normalizeAiBody(decoded);
      }
    }

    if (current is Map && current['body'] != null) {
      return _normalizeAiBody(current['body']);
    }

    return current;
  }

  dynamic _decodeJsonString(String input) {
    final String cleaned = input
        .replaceAll(RegExp(r'^```json\s*'), '')
        .replaceAll(RegExp(r'^```\s*'), '')
        .replaceAll(RegExp(r'\s*```$'), '')
        .trim();

    if (cleaned.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(cleaned);
    } catch (_) {
      final int objectStart = cleaned.indexOf('{');
      final int objectEnd = cleaned.lastIndexOf('}');
      if (objectStart != -1 && objectEnd > objectStart) {
        final String candidate = cleaned.substring(objectStart, objectEnd + 1);
        try {
          return jsonDecode(candidate);
        } catch (_) {
          return null;
        }
      }

      final int listStart = cleaned.indexOf('[');
      final int listEnd = cleaned.lastIndexOf(']');
      if (listStart != -1 && listEnd > listStart) {
        final String candidate = cleaned.substring(listStart, listEnd + 1);
        try {
          return jsonDecode(candidate);
        } catch (_) {
          return null;
        }
      }
    }

    return null;
  }
}
