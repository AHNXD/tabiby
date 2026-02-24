import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/diet_plan_response.dart';
import '../models/diet_request_data.dart';
import 'diet_repository.dart';

class DietRepositoryIplm implements DietRepository {
  DietRepositoryIplm(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<Either<Failure, DietPlanResponse>> generateDietPlan(
    DietRequestData request,
  ) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.generateDietPlanAutomation,
        data: request.toJson(),
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      );

      final dynamic normalized = _normalizeN8nBody(response.data);

      if (normalized is Map<String, dynamic> && normalized['error'] != null) {
        return left(ServerFailure(normalized['error'].toString()));
      }

      if (normalized is! Map<String, dynamic>) {
        return left(const ServerFailure(ErrorHandler.errorTryAgain));
      }

      return right(DietPlanResponse.fromJson(normalized));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  dynamic _normalizeN8nBody(dynamic source) {
    dynamic current = source;

    if (current is List && current.isNotEmpty) {
      current = current.first;
    }

    if (current is Map<String, dynamic>) {
      if (current['content'] is Map) {
        final dynamic content = current['content'];
        if (content is Map<String, dynamic> && content['parts'] is List) {
          final List<dynamic> parts = content['parts'] as List<dynamic>;
          if (parts.isNotEmpty && parts.first is Map) {
            final dynamic partText = (parts.first as Map)['text'];
            if (partText != null) {
              current = partText;
            }
          }
        }
      }

      if (current is Map<String, dynamic> && current['output'] != null) {
        current = current['output'];
      }

      if (current is Map<String, dynamic> && current['text'] != null) {
        current = current['text'];
      }
    }

    if (current is String) {
      final dynamic decoded = _decodeJsonString(current);
      if (decoded != null) {
        return _normalizeN8nBody(decoded);
      }
    }

    if (current is Map<String, dynamic> && current['body'] != null) {
      return _normalizeN8nBody(current['body']);
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
    }

    return null;
  }
}
