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
  Future<Either<Failure, DoctorsModel>> getDoctors(
    int? centerID,
    int? specialtyID,
  ) async {
    try {
      String endpoint = Urls.doctors;
      if (centerID != null && specialtyID != null) {
        endpoint += "$specialtyID/$centerID";
      } else if (centerID != null) {
        endpoint += "/0/$centerID";
      } else if (specialtyID != null) {
        endpoint += "/$specialtyID";
      }

      var resp = await _apiServices.get(endPoint: endpoint);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        DoctorsModel doctors = DoctorsModel.fromJson(resp.data['data']);

        return right(doctors);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
   @override
     Future<Either<Failure, Doctor>> getDoctor(
    int? doctorID,
  ) async {
    try {

      var resp = await _apiServices.get(endPoint: "${Urls.doctor}/$doctorID");

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        Doctor doctor = Doctor.fromJson(resp.data['data']);
        return right(doctor);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
