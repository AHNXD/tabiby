import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/category_model.dart';
import '../models/diagnosis_request_model.dart';
import '../models/diagnosis_result_model.dart';
import '../models/question_model.dart';

abstract class DiagnosisRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Question>>> getQuestions(
    int categoryId,
  );

  Future<Either<Failure, DiagnosisResult>> postDiagnosis(
    DiagnosisRequest request,
  );
}
