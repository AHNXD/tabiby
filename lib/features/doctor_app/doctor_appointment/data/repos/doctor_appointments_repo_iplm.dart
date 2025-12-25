import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/doctor_appointments_model.dart';
import 'doctor_appointment_repo.dart';

class DoctorAppointmentRepoIplm implements DoctorAppointmentsRepo {
  final ApiServices _apiServices;

  DoctorAppointmentRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, DoctorAppointmentsModel>> getDoctorAppointments(
    int? center,
    String? date,
  ) async {
    try {
      String endpoint = Urls.doctorAppointments;
      if (center != null && date != null) {
        endpoint += "/$center/$date";
      } else if (center != null) {
        endpoint += "/$center";
      } else if (date != null) {
        endpoint += "/0/$date";
      }

      var resp = await _apiServices.get(endPoint: endpoint);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        DoctorAppointmentsModel doctorsAppointment = DoctorAppointmentsModel.fromJson(resp.data['data']);

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

