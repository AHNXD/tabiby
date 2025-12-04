import 'package:dartz/dartz.dart';
import 'package:tabiby/features/user_app/specialties/data/models/specialties_model.dart';

import '../../../../../core/errors/failuer.dart';


abstract class SpecialtiesRepo {
  Future<Either<Failure, SpecialtiesModel>> getSpecialties();
}
