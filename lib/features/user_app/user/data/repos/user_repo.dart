import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../../../../auth/data/models/user_model.dart';

abstract class UserRepo {
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, bool>> deleteProfile();
  Future<Either<Failure, UserModel>> updateProfile(
    Map<String, dynamic> registerData,
  );
}
