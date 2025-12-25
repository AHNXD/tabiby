import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/doctor_appointments_model.dart';

abstract class DoctorAppointmentsRepo {
  Future<Either<Failure, DoctorAppointmentsModel>> getDoctorAppointments(
    int? center,
    String? date,
  );
  
}
