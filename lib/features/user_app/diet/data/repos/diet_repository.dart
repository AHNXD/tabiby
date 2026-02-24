import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/diet_plan_response.dart';
import '../models/diet_request_data.dart';

abstract class DietRepository {
  Future<Either<Failure, DietPlanResponse>> generateDietPlan(
    DietRequestData request,
  );
}
