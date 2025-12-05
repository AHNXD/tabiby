import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/home_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, HomeModel>> getHome();
}
