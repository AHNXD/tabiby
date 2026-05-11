import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../Api_services/api_services.dart';
import '../Api_services/urls.dart';
import '../errors/error_handler.dart';
import '../errors/failuer.dart';
import '../models/ai_usage_models.dart';
import 'ai_usage_repo.dart';

class AiUsageRepoIplm implements AiUsageRepo {
  final ApiServices _apiServices;

  AiUsageRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, AiRemainingUsageResponse>> getRemaining() async {
    try {
      final resp = await _apiServices.get(endPoint: Urls.aiRemaining);
      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        return right(AiRemainingUsageResponse.fromJson(resp.data));
      }
      return left(ServerFailure(ErrorHandler.defaultMessage()));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AiUseFeatureResponse>> useFeature(
    AiFeatureType featureType,
  ) async {
    try {
      final resp = await _apiServices.post(
        endPoint: Urls.aiUseFeature,
        data: {'feature_type': featureType.apiValue},
      );

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        return right(
          AiUseFeatureResponse.fromJson(
            resp.data,
            httpStatusCode: resp.statusCode,
          ),
        );
      }

      return left(ServerFailure(ErrorHandler.defaultMessage()));
    } on DioException catch (e) {
      final int? status = e.response?.statusCode;
      final data = e.response?.data;

      if ((status == 404 || status == 429) && data is Map<String, dynamic>) {
        return right(
          AiUseFeatureResponse.fromJson(data, httpStatusCode: status),
        );
      }

      return left(ErrorHandler.handle(e));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
