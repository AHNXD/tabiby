import 'package:dartz/dartz.dart';
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
}
