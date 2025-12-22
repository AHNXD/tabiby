import 'package:dartz/dartz.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/times_model.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/centers_appointment_model.dart';
import '../models/days_model.dart';

abstract class AddAppoinmentRepo {
  Future<Either<Failure, List<Centers>>> getCenters(int? doctorID);
  Future<Either<Failure, List<Days>>> getDays(int? doctorID, int? centerID);
  Future<Either<Failure, TimesModel>> getTimes(
    int? doctorID,
    int? centerID,
    String date,
  );
  Future<Either<Failure, bool>> bookAppointment(
    String doctorID,
    String centerID,
    String date,
    String periodName,
    String period,
    String? note,
  );
}
