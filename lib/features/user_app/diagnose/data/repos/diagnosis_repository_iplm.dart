import 'package:dartz/dartz.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/category_model.dart';
import '../models/diagnosis_request_model.dart';
import '../models/diagnosis_result_model.dart';
import '../models/question_model.dart';

class DiagnosisRepositoryIplm implements DiagnosisRepository {
  final ApiServices _apiServices;

  DiagnosisRepositoryIplm(this._apiServices);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final response = await _apiServices.get(
        endPoint: Urls.baseUrl + Urls.categories,
      );
      List<dynamic> data = response.data['categories'];
      return right(data.map((json) => Category.fromJson(json)).toList());
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions(
    int categoryId,
  ) async {
    try {
      final response = await _apiServices.get(
        endPoint: Urls.baseUrl + Urls.questions(categoryId),
      );
      List<dynamic> data = response.data['questions'];
      return right(data.map((json) => Question.fromJson(json)).toList());
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, DiagnosisResult>> postDiagnosis(
    DiagnosisRequest request,
  ) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.baseUrl + Urls.diagnose,
        data: request.toJson(),
      );
      return right(DiagnosisResult.fromJson(response.data));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
