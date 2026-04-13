import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/doctors_query_params.dart';
import '../../../doctor_details/data/models/doctor_model.dart';

abstract class DoctorsRepo {
  Future<Either<Failure, DoctorsModel>> getDoctors(
    int? centerID,
    int? specialtyID,
    int page,
    DoctorsQueryParams queryParams,
  );

  Future<Either<Failure, Doctor>> getDoctor(int? doctorID);
}
