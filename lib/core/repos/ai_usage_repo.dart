import 'package:dartz/dartz.dart';

import '../errors/failuer.dart';
import '../models/ai_usage_models.dart';

abstract class AiUsageRepo {
  Future<Either<Failure, AiRemainingUsageResponse>> getRemaining();

  Future<Either<Failure, AiUseFeatureResponse>> useFeature(
    AiFeatureType featureType,
  );
}
