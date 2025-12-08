  import 'package:dartz/dartz.dart';
  import '../../../../../core/Api_services/api_services.dart';
  import '../../../../../core/Api_services/urls.dart';
  import '../../../../../core/errors/error_handler.dart';
  import '../../../../../core/errors/failuer.dart';
  import '../models/home_model.dart';
  import 'home_repo.dart';

  class HomeRepoIplm implements HomeRepo {
    final ApiServices _apiServices;

    HomeRepoIplm(this._apiServices);

    @override
    Future<Either<Failure, HomeModel>> getHome() async {
      try {
        var resp = await _apiServices.get(endPoint: Urls.home);

        if (resp.statusCode == 200 && resp.data['status'] == true) {
          HomeModel home = HomeModel.fromJson(resp.data['data']);

          return right(home);
        }

        return left(
          ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
        );
      } catch (e) {
        return left(ServerFailure(e.toString()));
      }
    }
  }
