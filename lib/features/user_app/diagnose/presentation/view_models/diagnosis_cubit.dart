import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

import '../../data/models/diagnosis_request_model.dart';
import '../../data/models/symptom_model.dart';
import '../../data/repos/diagnosis_repository.dart';
import 'diagnosis_state.dart';

export 'diagnosis_state.dart';

class DiagnosisCubit extends Cubit<DiagnosisState> {
  final DiagnosisRepository _repository;
  final MedicalFilesRepo _medicalFilesRepo;
  final ImagePicker _imagePicker = ImagePicker();

  DiagnosisCubit(this._repository, this._medicalFilesRepo)
    : super(DiagnosisState.initial());

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

  Future<void> pickXrayImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image == null) {
      return;
    }

    emit(
      state.copyWith(
        selectedXrayImagePath: image.path,
        selectedXrayTitle: null,
        xrayState: ViewState.idle,
        errorMessage: '',
        clearXrayDiagnosisResult: true,
      ),
    );
  }

  Future<List<MedicalFile>> loadAvailableXrayMedicalFiles() async {
    emit(
      state.copyWith(
        xrayMedicalFilesState: ViewState.loading,
        errorMessage: '',
      ),
    );

    final result = await _medicalFilesRepo.getMedicalFiles();

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            xrayMedicalFilesState: ViewState.error,
            errorMessage: failure.message,
            xrayMedicalFiles: const <MedicalFile>[],
          ),
        );
        return const <MedicalFile>[];
      },
      (files) {
        final List<MedicalFile> radiologyFiles = files
            .where(
              (file) =>
                  file.type == MedicalFileType.radiology &&
                  (file.hasLocalFile || file.hasRemoteFile),
            )
            .toList();

        emit(
          state.copyWith(
            xrayMedicalFilesState: ViewState.success,
            xrayMedicalFiles: radiologyFiles,
            errorMessage: '',
          ),
        );

        return radiologyFiles;
      },
    );
  }

  Future<void> selectMedicalFileForXray(MedicalFile file) async {
    emit(
      state.copyWith(
        xrayMedicalFilesState: ViewState.loading,
        errorMessage: '',
      ),
    );

    final result = await _medicalFilesRepo.downloadMedicalFileToTemp(file);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            xrayMedicalFilesState: ViewState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (localPath) {
        emit(
          state.copyWith(
            selectedXrayImagePath: localPath,
            selectedXrayTitle: file.title,
            xrayState: ViewState.idle,
            xrayMedicalFilesState: ViewState.success,
            errorMessage: '',
            clearXrayDiagnosisResult: true,
          ),
        );
      },
    );
  }

  void clearSelectedXrayImage() {
    emit(
      state.copyWith(
        xrayState: ViewState.idle,
        errorMessage: '',
        clearSelectedXrayImage: true,
        clearSelectedXrayTitle: true,
        clearXrayDiagnosisResult: true,
      ),
    );
  }

  Future<void> analyzeSelectedXray() async {
    if (!state.hasSelectedXrayImage) {
      emit(
        state.copyWith(
          xrayState: ViewState.error,
          errorMessage: 'xray_select_image_first',
          clearXrayDiagnosisResult: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        xrayState: ViewState.loading,
        errorMessage: '',
        clearXrayDiagnosisResult: true,
      ),
    );

    final result = await _repository.analyzeChestXray(
      state.selectedXrayImagePath!,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            xrayState: ViewState.error,
            errorMessage: failure.message,
            clearXrayDiagnosisResult: true,
          ),
        );
      },
      (imageDiagnosisResult) {
        emit(
          state.copyWith(
            xrayState: ViewState.success,
            xrayDiagnosisResult: imageDiagnosisResult,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void resetXrayDiagnosis() {
    emit(
      state.copyWith(
        xrayState: ViewState.idle,
        xrayMedicalFilesState: ViewState.idle,
        errorMessage: '',
        clearSelectedXrayImage: true,
        clearSelectedXrayTitle: true,
        clearXrayDiagnosisResult: true,
      ),
    );
  }

  void clearError() {
    if (state.errorMessage.isEmpty) {
      return;
    }

    emit(state.copyWith(errorMessage: ''));
  }

  void resetDiagnosis() {
    emit(DiagnosisState.initial());
  }
}
