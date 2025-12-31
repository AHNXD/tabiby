import 'package:dartz/dartz.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import 'reset_password_repo.dart';

class ResetPasswordRepoImpl implements ResetPasswordRepo {
  final ApiServices _apiServices;

  ResetPasswordRepoImpl(this._apiServices);
  @override
  Future<Either<Failure, bool>> forgetPassword({required String email}) async {
    try {
      final resp = await _apiServices.post(
        endPoint: Urls.forgetPassword,
        data: {"email": email},
      );

      if (resp.statusCode == 200 && resp.data['status']) {
        return Right(true);
      } else {
        return Left(
          ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPasswordInApp({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.resetPasswordInApp(password, confirmPassword),
        data: {},
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        return Right(true);
      }
      return Left(
        ServerFailure(
          response.data["message"] ?? ErrorHandler.defaultMessage(),
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required int otp,
    required String password,
    required String email,
  }) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.resetPassword(otp, password),
        data: {"email": email},
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        return Right(true);
      }
      return Left(
        ServerFailure(
          response.data["message"] ?? ErrorHandler.defaultMessage(),
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
