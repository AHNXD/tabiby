import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../../../../auth/data/models/user_model.dart';
import 'user_repo.dart';

class UserRepoIplm implements UserRepo {
  final ApiServices _apiServices;

  UserRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.getProfile);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        UserModel user = UserModel.fromJson(resp.data['data']['user']);

        return right(user);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> deleteProfile() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.getProfile);

      if (resp.statusCode == 201 && resp.data['status'] == true) {
        UserModel user = UserModel.fromJson(resp.data['data']['user']);

        return right(user);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.getProfile);

      if (resp.statusCode == 201 && resp.data['status'] == true) {
        UserModel user = UserModel.fromJson(resp.data['data']['user']);

        return right(user);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
