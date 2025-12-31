import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failuer.dart';
import '../../models/rating_status_model.dart';

abstract class RatingRepo {
  Future<Either<Failure, RatingStatus>> checkAppointment(int id);
  Future<Either<Failure, bool>> addRate(int id, int rate, String comment);
}
