import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/specialties_model.dart';
import 'user_repo.dart';

class SpecialtiesRepoIplm implements SpecialtiesRepo {
  final ApiServices _apiServices;

  SpecialtiesRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, SpecialtiesModel>> getSpecialties() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.specialists);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        SpecialtiesModel specialties = SpecialtiesModel.fromJson(
          resp.data['data'],
        );

        return right(specialties);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
