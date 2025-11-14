import 'package:flutter_bloc/flutter_bloc.dart';
import 'diagnosis_state.dart';
import '../../data/models/diagnosis_request_model.dart';
import '../../data/repos/diagnosis_repository.dart';

export 'diagnosis_state.dart';

class DiagnosisCubit extends Cubit<DiagnosisState> {
  final DiagnosisRepository _repository;
  String lang = "ar";
  DiagnosisCubit(this._repository) : super(DiagnosisState.initial());

  Future<void> fetchCategories() async {
    emit(state.copyWith(categoryState: ViewState.loading));

    final result = await _repository.getCategories();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            categoryState: ViewState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (categoriesList) {
        emit(
          state.copyWith(
            categoryState: ViewState.success,
            categories: categoriesList,
          ),
        );
      },
    );
  }

  Future<void> selectCategory(int categoryId) async {
    emit(
      state.copyWith(
        questionState: ViewState.loading,
        selectedCategoryId: categoryId,
      ),
    );

    final result = await _repository.getQuestions(categoryId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            questionState: ViewState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (questionsList) {
        final answers = {for (var q in questionsList) q.id: 0};

        emit(
          state.copyWith(
            questionState: ViewState.success,
            questions: questionsList,
            answers: answers,
          ),
        );
      },
    );
  }

  void answerQuestion(int questionId, bool answer) {
    // IMPORTANT: We must create a *new* map, not modify the old one,
    // for Equatable to detect the state change.
    final newAnswers = Map<int, int>.from(state.answers);
    newAnswers[questionId] = answer ? 1 : 0;

    // Emit the new state with the updated answers map
    emit(state.copyWith(answers: newAnswers));
  }

  Future<void> submitDiagnosis(String lang) async {
    // Read the category ID from the current state
    if (state.selectedCategoryId == null) return;

    emit(state.copyWith(resultState: ViewState.loading));

    // Convert keys to string for the API
    final apiResponses = state.answers.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final request = DiagnosisRequest(
      lang: lang,
      categoryId: state.selectedCategoryId!,
      responses: apiResponses,
    );

    final result = await _repository.postDiagnosis(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            resultState: ViewState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (diagnosisResult) {
        emit(
          state.copyWith(
            resultState: ViewState.success,
            diagnosisResult: diagnosisResult,
          ),
        );
      },
    );
  }

  void resetDiagnosis() {
    emit(DiagnosisState.initial());
  }
}
