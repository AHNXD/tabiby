import 'package:dartz/dartz.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/booking_request_model.dart';
import '../models/centers_appointment_model.dart';
import '../models/days_model.dart';
import '../models/times_model.dart';
import 'add_appoinment_repo.dart';

class AddAppoinmentRepoIplm implements AddAppoinmentRepo {
  final ApiServices _apiServices;

  AddAppoinmentRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, bool>> bookAppointment(
    AppointmentBookingRequest request,
  ) async {
    try {
      final resp = await _apiServices.post(
        endPoint:
            '${Urls.addAppointment}/${request.doctorId}/${request.centerId}/${request.date}/${request.periodName}',
        data: request.toJson(),
      );

      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300 &&
          resp.data['status'] == true) {
        return right(true);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<Centers>>> getCenters(int? doctorID) async {
    try {
      final resp = await _apiServices.get(
        endPoint: '${Urls.getCenters}/$doctorID',
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        final CentersAppointmentModel centers =
            CentersAppointmentModel.fromJson(resp.data['data']);

        return right(centers.centers ?? []);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<Days>>> getDays(
    int? doctorID,
    int? centerID,
  ) async {
    try {
      final resp = await _apiServices.get(
        endPoint: '${Urls.getDays}/$doctorID/$centerID',
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        final DaysModel days = DaysModel.fromJson(resp.data['data']['days']);

        return right(days.days ?? []);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<LabTestOption>>> getLabTests(int centerId) async {
    try {
      final resp = await _apiServices.get(
        endPoint: Urls.labTestsByCenter(centerId),
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List<dynamic>) {
        final List<LabTestOption> tests = (resp.data['data'] as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .map(LabTestOption.fromJson)
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
  Future<Either<Failure, List<MedicalImageTypeOption>>> getMedicalImageTypes(
    int centerId,
  ) async {
    try {
      final resp = await _apiServices.get(
        endPoint: Urls.medicalImageTypesByCenter(centerId),
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List<dynamic>) {
        final List<MedicalImageTypeOption> types =
            (resp.data['data'] as List<dynamic>)
                .whereType<Map<String, dynamic>>()
                .map(MedicalImageTypeOption.fromJson)
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
  Future<Either<Failure, TimesModel>> getTimes(
    int? doctorID,
    int? centerID,
    String date,
  ) async {
    try {
      final resp = await _apiServices.get(
        endPoint: '${Urls.getTimes}/$doctorID/$centerID/$date',
      );

      if (resp.statusCode == 200) {
        final TimesModel times = TimesModel.fromJson(resp.data);
        return right(times);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }
}
