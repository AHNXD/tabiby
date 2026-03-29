import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/doctor_appointment_details_model.dart';
import '../models/end_appointment_request.dart';

abstract class DoctorAppointmentDetailsRepo {
  Future<Either<Failure, DoctorAppointmentDetailsModel>>
  getDoctorAppointmentDetails(int id);
  Future<Either<Failure, String>> cancelAppointment(int appointmentId);
  Future<Either<Failure, String>> endAppointment(EndAppointmentRequest request);
}
