import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../../../../../core/utils/cache_helper.dart';
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
  Future<Either<Failure, bool>> deleteProfile() async {
    try {
      var resp = await _apiServices.post(
        endPoint: Urls.deleteProfile,
        data: {},
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        CacheHelper.removeData(key: 'token');
        CacheHelper.removeData(key: 'role');
        return right(true);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(
    Map<String, dynamic> registerData,
  ) async {
    try {
      FormData formData = FormData.fromMap({});
      for (var entry in registerData.entries) {
        if (entry.value is File) {
          File file = entry.value;
          String fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              entry.key,
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        } else {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }

      var resp = await _apiServices.post(
        endPoint: Urls.updateProfile,
        data: formData,
      );

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
}
