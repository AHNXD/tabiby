import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/centers_appointment_model.dart';
import '../models/days_model.dart';
import '../models/times_model.dart';
import 'add_appoinment_repo.dart';

class AddAppoinmentRepoIplm implements AddAppoinmentRepo {
  final ApiServices _apiServices;

  AddAppoinmentRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, bool>> bookAppointment(
    String doctorID,
    String centerID,
    String date,
    String periodName,
    String period,
    String? note,
  ) async {
    try {
      var resp = await _apiServices.post(
        endPoint:
            "${Urls.addAppointment}/$doctorID/$centerID/$date/$periodName",
        data: {'time': period, 'note': note ?? ""},
      );

      if (resp.statusCode == 201 && resp.data['status'] == true) {
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
  Future<Either<Failure, List<Centers>>> getCenters(int? doctorID) async {
    try {
      var resp = await _apiServices.get(
        endPoint: "${Urls.getCenters}/$doctorID",
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        CentersAppointmentModel centers = CentersAppointmentModel.fromJson(
          resp.data['data'],
        );

        return right(centers.centers ?? []);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Days>>> getDays(
    int? doctorID,
    int? centerID,
  ) async {
    try {
      var resp = await _apiServices.get(
        endPoint: "${Urls.getDays}/$doctorID/$centerID",
      );

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        DaysModel days = DaysModel.fromJson(resp.data['data']['days']);

        return right(days.days ?? []);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TimesModel>> getTimes(
    int? doctorID,
    int? centerID,
    String date,
  ) async {
    try {
      var resp = await _apiServices.get(
        endPoint: "${Urls.getTimes}/$doctorID/$centerID/$date",
      );

      if (resp.statusCode == 200) {
        TimesModel times = TimesModel.fromJson(resp.data);

        return right(times);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
