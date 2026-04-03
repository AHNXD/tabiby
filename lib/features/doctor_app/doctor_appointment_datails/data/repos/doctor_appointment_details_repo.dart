import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/appointment_request_option.dart';
import '../models/doctor_appointment_details_model.dart';
import '../models/end_appointment_request.dart';
import '../models/end_appointment_result.dart';

abstract class DoctorAppointmentDetailsRepo {
  Future<Either<Failure, DoctorAppointmentDetailsModel>>
  getDoctorAppointmentDetails(int id);
  Future<Either<Failure, String>> cancelAppointment(int appointmentId);
  Future<Either<Failure, List<AppointmentRequestOption>>> getLabTests({
    int? centerId,
  });
  Future<Either<Failure, List<AppointmentRequestOption>>> getMedicalImageTypes({
    int? centerId,
  });
  Future<Either<Failure, EndAppointmentResult>> endAppointment(
    EndAppointmentRequest request,
  );
}
