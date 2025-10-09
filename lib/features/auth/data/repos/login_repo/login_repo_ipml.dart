import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../../../../../core/utils/cache_helper.dart';
import '../../../../../core/utils/constats.dart';
import '../../models/user_model.dart';
import 'login_repo.dart';

class LoginRepoIpml implements LoginRepo {
  final ApiServices apiServices;

  LoginRepoIpml(this.apiServices);
  @override
  Future<Either<Failure, UserModel>> login(String pass, String phone) async {
    try {
      var resp = await apiServices
          .post(endPoint: Urls.login, data: {"phone": phone, "password": pass});
      if (resp.statusCode == 200 && resp.data['success']) {
        CacheHelper.setString(key: 'token', value: resp.data["data"]["token"]);
        CacheHelper.setString(
            key: "userId", value: resp.data['data']['user']['id'].toString());
        isGuest = false;
        return right(UserModel.fromJson(resp.data["data"]["user"]));
      }
      return left(
          resp.data['message'] ?? ServerFailure(ErrorHandler.defaultMessage()));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
