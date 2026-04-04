import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/diet_plan_history_item.dart';
import '../models/diet_plan_response.dart';
import '../models/diet_request_data.dart';
import '../models/paginated_diet_plans_result.dart';
import 'diet_repository.dart';

class DietRepositoryIplm implements DietRepository {
  DietRepositoryIplm(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<Either<Failure, DietPlanHistoryItem>> generateDietPlan(
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

      final generatedPlan = DietPlanResponse.fromJson(normalized);
      return _saveDietPlan(request: request, plan: generatedPlan);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedDietPlansResult>> getDietPlans({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiServices.get(
        endPoint: '${Urls.nutritionPlans}?page=$page&limit=$limit',
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return right(
          PaginatedDietPlansResult.fromJson(
            response.data as Map<String, dynamic>,
          ),
        );
      }

      return left(
        ServerFailure(
          _extractMessage(response.data) ?? ErrorHandler.errorTryAgain,
        ),
      );
    } catch (e) {
      return left(_mapPlanFailure(e));
    }
  }

  @override
  Future<Either<Failure, DietPlanHistoryItem>> getDietPlanById(
    String id,
  ) async {
    try {
      final response = await _apiServices.get(
        endPoint: Urls.nutritionPlanById(id),
      );

      final item = _extractHistoryItem(response.data['data']);
      if (item != null) {
        return right(item);
      }

      return left(const ServerFailure(ErrorHandler.errorTryAgain));
    } catch (e) {
      return left(_mapPlanFailure(e, notFoundMessage: 'notFound'));
    }
  }

  @override
  Future<Either<Failure, DietPlanHistoryItem>> getLatestDietPlan() async {
    try {
      final response = await _apiServices.get(
        endPoint: Urls.latestNutritionPlan,
      );

      final item = _extractHistoryItem(response.data['data']);
      if (item != null) {
        return right(item);
      }

      return left(const ServerFailure(ErrorHandler.errorTryAgain));
    } catch (e) {
      return left(
        _mapPlanFailure(e, notFoundMessage: 'diet_result_no_plan_found'),
      );
    }
  }

  Future<Either<Failure, DietPlanHistoryItem>> _saveDietPlan({
    required DietRequestData request,
    required DietPlanResponse plan,
  }) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.nutritionPlans,
        data: {'request': request.toJson(), 'plan': plan.toJson()},
      );

      final item = _extractHistoryItem(response.data['data']?['item']);
      if (response.statusCode == 201 && item != null) {
        return right(item);
      }

      return left(
        ServerFailure(
          _extractMessage(response.data) ?? ErrorHandler.errorTryAgain,
        ),
      );
    } catch (e) {
      return left(_mapPlanFailure(e));
    }
  }

  DietPlanHistoryItem? _extractHistoryItem(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return DietPlanHistoryItem.fromJson(raw);
    }
    if (raw is Map) {
      return DietPlanHistoryItem.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Failure _mapPlanFailure(dynamic error, {String? notFoundMessage}) {
    if (error is DioException &&
        error.response?.statusCode == 404 &&
        notFoundMessage != null) {
      return ServerFailure(notFoundMessage);
    }

    return ErrorHandler.handle(error);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'].toString();
    }
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
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
