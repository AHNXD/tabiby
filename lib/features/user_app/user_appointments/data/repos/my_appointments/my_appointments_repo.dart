import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failuer.dart';
import '../../models/appointments_model.dart';

abstract class MyAppointmentsRepo {
  Future<Either<Failure, Appointments>> getMyAppointments();
}
