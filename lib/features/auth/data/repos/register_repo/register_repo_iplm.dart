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
      final fcmToken = await CacheHelper.getData(key: "fcm_token");
      Map<String, dynamic> finalData = Map.from(registerData);
      finalData['fcm_token'] = fcmToken;
      var resp = await _apiServices.post(
        endPoint: Urls.register,
        data: finalData,
      );

      if (resp.statusCode == 201 && resp.data['status'] == true) {
        CacheHelper.setString(
          key: 'token',
          value: resp.data['data']['user']['main_data']['token'],
        );
        CacheHelper.setString(
          key: 'role',
          value: resp.data['data']['user']['main_data']['role'].toString(),
        );
        UserModel user = UserModel.fromJson(resp.data['data']['user']);

        return right(user);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      print(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }
}
