import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/diagnosis_request_model.dart';
import '../models/diagnosis_result_model.dart';
import '../models/symptom_model.dart';

abstract class DiagnosisRepository {
  Future<Either<Failure, List<Symptom>>> getSymptoms(String bodyPart);

  Future<Either<Failure, DiagnosisResult>> postDiagnosis(
    DiagnosisRequest request,
  );
}
