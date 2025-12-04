import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../../../../../core/utils/cache_helper.dart';
import '../../models/user_model.dart';
import 'register_repo.dart';

class RegisterRepoIplm implements RegisterRepo {
  final ApiServices _apiServices;

  RegisterRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, UserModel>> register(
    Map<String, dynamic> registerData,
  ) async {
    try {
      var resp = await _apiServices.post(
        endPoint: Urls.register,
        data: registerData,
      );
      if (resp.statusCode == 200 && resp.data['status']) {
        CacheHelper.setString(key: 'token', value: resp.data['token']);
        UserModel user = UserModel.fromJson(resp.data);

        return right(user);
      }
      return left(
        resp.data['message'] ?? ServerFailure(ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
