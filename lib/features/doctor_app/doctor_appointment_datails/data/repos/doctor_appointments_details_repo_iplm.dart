import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/appointment_request_option.dart';
import '../models/doctor_appointment_details_model.dart';
import '../models/end_appointment_request.dart';
import '../models/end_appointment_result.dart';
import 'doctor_appointment_details_repo.dart';

class DoctorAppointmentDetailsRepoIplm implements DoctorAppointmentDetailsRepo {
  final ApiServices _apiServices;

  DoctorAppointmentDetailsRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, DoctorAppointmentDetailsModel>>
  getDoctorAppointmentDetails(int id) async {
    try {
      final String endpoint = "${Urls.doctorAppointmentDetails}/$id";
      final resp = await _apiServices.get(endPoint: endpoint);
      final Map<String, dynamic>? appointmentJson = _extractAppointment(
        resp.data,
      );

      if (resp.statusCode == 200 && appointmentJson != null) {
        return right(DoctorAppointmentDetailsModel.fromJson(appointmentJson));
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentRequestOption>>> getLabTests({
    int? centerId,
  }) async {
    try {
      final resp = await _apiServices.get(
        endPoint: centerId != null
            ? Urls.labTestsByCenter(centerId)
            : Urls.labTests,
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List<dynamic>) {
        final List<AppointmentRequestOption> tests =
            (resp.data['data'] as List<dynamic>)
                .whereType<Map<String, dynamic>>()
                .map(AppointmentRequestOption.fromJson)
                .toList();

        return right(tests);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentRequestOption>>> getMedicalImageTypes({
    int? centerId,
  }) async {
    try {
      final resp = await _apiServices.get(
        endPoint: centerId != null
            ? Urls.medicalImageTypesByCenter(centerId)
            : Urls.medicalImageTypes,
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List<dynamic>) {
        final List<AppointmentRequestOption> types =
            (resp.data['data'] as List<dynamic>)
                .whereType<Map<String, dynamic>>()
                .map(AppointmentRequestOption.fromJson)
                .toList();

        return right(types);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, String>> cancelAppointment(int id) async {
    try {
      final endpoint = Urls.cancelAppointment;

      var response = await _apiServices.post(
        endPoint: endpoint,
        data: {"appointment_id": id},
      );

      if (response.statusCode == 200) {
        return right(
          response.data['message'] ?? 'Appointment cancelled successfully',
        );
      }

      return left(
        ServerFailure(
          response.data['message'] ?? ErrorHandler.defaultMessage(),
        ),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EndAppointmentResult>> endAppointment(
    EndAppointmentRequest request,
  ) async {
    try {
      final endpoint = Urls.endAppointment;

      final response = await _apiServices.post(
        endPoint: endpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return right(EndAppointmentResult.fromJson(response.data));
      }

      return left(
        ServerFailure(
          response.data['message'] ?? ErrorHandler.defaultMessage(),
        ),
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
