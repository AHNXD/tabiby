import 'package:dartz/dartz.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointment_details_model.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';
import '../../../../../../core/Api_services/api_services.dart';
import '../../../../../../core/Api_services/urls.dart';
import '../../../../../../core/errors/error_handler.dart';
import '../../../../../../core/errors/failuer.dart';
import 'my_appointments_repo.dart';

class MyAppointmentsRepoIplm implements MyAppointmentsRepo {
  final ApiServices _apiServices;

  MyAppointmentsRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, Appointments>> getMyAppointments() async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.getMyAppointments);

      if (resp.statusCode == 200) {
        Appointments myAppointments = Appointments.fromJson(
          resp.data['appointment'],
        );

        return right(myAppointments);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentDetailsModel>> getAppointmentDetails(
    int appointmentId,
  ) async {
    try {
      final dynamic resp = await _apiServices.get(
        endPoint: '${Urls.doctorAppointmentDetails}/$appointmentId',
      );

      final Map<String, dynamic>? appointmentJson = _extractAppointment(
        resp.data,
      );

      if (resp.statusCode == 200 && appointmentJson != null) {
        return right(AppointmentDetailsModel.fromJson(appointmentJson));
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, String>> cancelAppointment(int appointmentId) async {
    try {
      final resp = await _apiServices.post(
        endPoint: Urls.cancelAppointment,
        data: {'appointment_id': appointmentId},
      );

      if (resp.statusCode == 200) {
        return right('appointment_cancelled_successfully');
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  Map<String, dynamic>? _extractAppointment(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic> &&
          responseData['data']['appointment'] is Map<String, dynamic>) {
        return responseData['data']['appointment'] as Map<String, dynamic>;
      }

      if (responseData['appointment'] is Map<String, dynamic>) {
        return responseData['appointment'] as Map<String, dynamic>;
      }
    }

    return null;
  }
}
