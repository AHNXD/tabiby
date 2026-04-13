import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/centers_query_params.dart';
import '../../../center_details/data/models/centers_model.dart';

abstract class CentersRepo {
  Future<Either<Failure, CentersModel>> getCenters(
    int page,
    CentersQueryParams queryParams,
  );

  Future<Either<Failure, Centers>> getCenter(int centerID);
}
