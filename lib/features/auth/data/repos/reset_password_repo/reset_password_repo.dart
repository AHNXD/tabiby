import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';

abstract class ResetPasswordRepo {
  Future<Either<Failure, bool>> forgetPassword({required String email});
  Future<Either<Failure, bool>> resetPasswordInApp({
    required String password,
    required String confirmPassword,
  });
  Future<Either<Failure, bool>> resetPassword({
    required int otp,
    required String password,
  });
}
