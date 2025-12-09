import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../../../doctor_details/data/models/doctor_model.dart';
import 'doctors_repo.dart';

class DoctorsRepoIplm implements DoctorsRepo {
  final ApiServices _apiServices;

  DoctorsRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, DoctorsModel>> getDoctors() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.doctors);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        DoctorsModel doctors = DoctorsModel.fromJson(
          resp.data['data'],
        );

        return right(doctors);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
