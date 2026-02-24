import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/diagnosis_request_model.dart';
import '../../data/models/symptom_model.dart';
import '../../data/repos/diagnosis_repository.dart';
import 'diagnosis_state.dart';

export 'diagnosis_state.dart';

class DiagnosisCubit extends Cubit<DiagnosisState> {
  final DiagnosisRepository _repository;

  DiagnosisCubit(this._repository) : super(DiagnosisState.initial());

  void selectBodyPart({required String partKey, required String partLabel}) {
    emit(
      state.copyWith(
        selectedBodyPartKey: partKey,
        selectedBodyPartLabel: partLabel,
        symptomsState: ViewState.idle,
        resultState: ViewState.idle,
        clearSymptoms: true,
        clearDiagnosisResult: true,
      ),
    );
  }

  void clearBodyPartSelection() {
    emit(
      state.copyWith(
        clearSelectedBodyPart: true,
        symptomsState: ViewState.idle,
        resultState: ViewState.idle,
        clearSymptoms: true,
        clearDiagnosisResult: true,
      ),
    );
  }

  Future<void> fetchSymptomsForSelectedPart() async {
    if (state.selectedBodyPartLabel == null ||
        state.selectedBodyPartLabel!.trim().isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        symptomsState: ViewState.loading,
        errorMessage: '',
        clearSymptoms: true,
        clearDiagnosisResult: true,
      ),
    );

    final result = await _repository.getSymptoms(state.selectedBodyPartLabel!);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            symptomsState: ViewState.error,
            errorMessage: failure.message,
            clearSymptoms: true,
          ),
        );
      },
      (symptomsList) {
        emit(
          state.copyWith(
            symptomsState: ViewState.success,
            symptoms: symptomsList,
            resultState: ViewState.idle,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void toggleSymptomSelection(int index, bool value) {
    if (index < 0 || index >= state.symptoms.length) {
      return;
    }

    final List<Symptom> updatedSymptoms = List<Symptom>.from(state.symptoms);
    final Symptom target = updatedSymptoms[index];
    updatedSymptoms[index] = target.copyWith(isSelected: value);

    emit(state.copyWith(symptoms: updatedSymptoms));
  }

  void answerQuestion(int symptomIndex, int questionIndex, dynamic answer) {
    if (symptomIndex < 0 || symptomIndex >= state.symptoms.length) {
      return;
    }

    final List<Symptom> updatedSymptoms = List<Symptom>.from(state.symptoms);
    final Symptom symptom = updatedSymptoms[symptomIndex];

    if (questionIndex < 0 || questionIndex >= symptom.questions.length) {
      return;
    }

    final List<SymptomQuestion> updatedQuestions = List<SymptomQuestion>.from(
      symptom.questions,
    );

    updatedQuestions[questionIndex] = updatedQuestions[questionIndex].copyWith(
      answer: answer,
    );

    updatedSymptoms[symptomIndex] = symptom.copyWith(
      questions: updatedQuestions,
    );

    emit(state.copyWith(symptoms: updatedSymptoms));
  }

  Future<void> submitDiagnosis() async {
    final List<Symptom> selectedSymptoms = state.selectedSymptoms;
    if (selectedSymptoms.isEmpty) {
      emit(
        state.copyWith(
          resultState: ViewState.error,
          errorMessage: 'no_symptom_selected',
          clearDiagnosisResult: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        resultState: ViewState.loading,
        errorMessage: '',
        clearDiagnosisResult: true,
      ),
    );

    final DiagnosisRequest request = DiagnosisRequest(
      selectedSymptoms: selectedSymptoms
          .map((symptom) => symptom.toSelectedPayload())
          .toList(),
    );

    final result = await _repository.postDiagnosis(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            resultState: ViewState.error,
            errorMessage: failure.message,
            clearDiagnosisResult: true,
          ),
        );
      },
      (diagnosisResult) {
        emit(
          state.copyWith(
            resultState: ViewState.success,
            diagnosisResult: diagnosisResult,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void resetDiagnosis() {
    emit(DiagnosisState.initial());
  }
}
