import 'package:dartz/dartz.dart';

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
}
