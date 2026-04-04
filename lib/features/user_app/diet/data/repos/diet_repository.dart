import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/diet_plan_history_item.dart';
import '../models/diet_request_data.dart';
import '../models/paginated_diet_plans_result.dart';

abstract class DietRepository {
  Future<Either<Failure, DietPlanHistoryItem>> generateDietPlan(
    DietRequestData request,
  );

  Future<Either<Failure, PaginatedDietPlansResult>> getDietPlans({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, DietPlanHistoryItem>> getDietPlanById(String id);

  Future<Either<Failure, DietPlanHistoryItem>> getLatestDietPlan();
}
