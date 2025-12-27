import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/doctor_appointment_details_model.dart';
import 'doctor_appointment_details_repo.dart';

class DoctorAppointmentDetailsRepoIplm implements DoctorAppointmentDetailsRepo {
  final ApiServices _apiServices;

  DoctorAppointmentDetailsRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, DoctorAppointmentDetailsModel>> getDoctorAppointmentDetails(
    int id,
  ) async {
    try {
      String endpoint ="${Urls.doctorAppointmentDetails}/$id";
    
      var resp = await _apiServices.get(endPoint: endpoint);

      if (resp.statusCode == 200 && resp.data['appointment'] != null) {
        DoctorAppointmentDetailsModel doctorsAppointment = DoctorAppointmentDetailsModel.fromJson(resp.data['appointment']);

        return right(doctorsAppointment);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
   
  }

