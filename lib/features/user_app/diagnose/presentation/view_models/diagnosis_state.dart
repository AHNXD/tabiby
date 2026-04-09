import 'package:equatable/equatable.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';

import '../../data/models/diagnosis_result_model.dart';
import '../../data/models/symptom_model.dart';
import '../../data/models/xray_diagnosis_result_model.dart';

enum ViewState { idle, loading, success, error }

class DiagnosisState extends Equatable {
  final ViewState symptomsState;
  final ViewState resultState;
  final ViewState xrayState;
  final ViewState xrayMedicalFilesState;
  final List<Symptom> symptoms;
  final List<MedicalFile> xrayMedicalFiles;
  final DiagnosisResult? diagnosisResult;
  final XrayDiagnosisResult? xrayDiagnosisResult;
  final String errorMessage;
  final String? selectedBodyPartKey;
  final String? selectedBodyPartLabel;
  final String? selectedXrayImagePath;
  final String? selectedXrayTitle;

  const DiagnosisState({
    this.symptomsState = ViewState.idle,
    this.resultState = ViewState.idle,
    this.xrayState = ViewState.idle,
    this.xrayMedicalFilesState = ViewState.idle,
    this.symptoms = const [],
    this.xrayMedicalFiles = const [],
    this.diagnosisResult,
    this.xrayDiagnosisResult,
    this.errorMessage = '',
    this.selectedBodyPartKey,
    this.selectedBodyPartLabel,
    this.selectedXrayImagePath,
    this.selectedXrayTitle,
  });

  factory DiagnosisState.initial() => const DiagnosisState();

  DiagnosisState copyWith({
    ViewState? symptomsState,
    ViewState? resultState,
    ViewState? xrayState,
    ViewState? xrayMedicalFilesState,
    List<Symptom>? symptoms,
    List<MedicalFile>? xrayMedicalFiles,
    DiagnosisResult? diagnosisResult,
    XrayDiagnosisResult? xrayDiagnosisResult,
    String? errorMessage,
    String? selectedBodyPartKey,
    String? selectedBodyPartLabel,
    String? selectedXrayImagePath,
    String? selectedXrayTitle,
    bool clearSymptoms = false,
    bool clearDiagnosisResult = false,
    bool clearSelectedBodyPart = false,
    bool clearXrayDiagnosisResult = false,
    bool clearSelectedXrayImage = false,
    bool clearSelectedXrayTitle = false,
  }) {
    return DiagnosisState(
      symptomsState: symptomsState ?? this.symptomsState,
      resultState: resultState ?? this.resultState,
      xrayState: xrayState ?? this.xrayState,
      xrayMedicalFilesState:
          xrayMedicalFilesState ?? this.xrayMedicalFilesState,
      symptoms: clearSymptoms ? const [] : symptoms ?? this.symptoms,
      xrayMedicalFiles: xrayMedicalFiles ?? this.xrayMedicalFiles,
      diagnosisResult: clearDiagnosisResult
          ? null
          : diagnosisResult ?? this.diagnosisResult,
      xrayDiagnosisResult: clearXrayDiagnosisResult
          ? null
          : xrayDiagnosisResult ?? this.xrayDiagnosisResult,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBodyPartKey: clearSelectedBodyPart
          ? null
          : selectedBodyPartKey ?? this.selectedBodyPartKey,
      selectedBodyPartLabel: clearSelectedBodyPart
          ? null
          : selectedBodyPartLabel ?? this.selectedBodyPartLabel,
      selectedXrayImagePath: clearSelectedXrayImage
          ? null
          : selectedXrayImagePath ?? this.selectedXrayImagePath,
      selectedXrayTitle: clearSelectedXrayTitle
          ? null
          : selectedXrayTitle ?? this.selectedXrayTitle,
    );
  }

  List<Symptom> get selectedSymptoms =>
      symptoms.where((symptom) => symptom.isSelected).toList();

  bool get hasSelectedXrayImage =>
      selectedXrayImagePath != null && selectedXrayImagePath!.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    symptomsState,
    resultState,
    xrayState,
    xrayMedicalFilesState,
    symptoms,
    xrayMedicalFiles,
    diagnosisResult,
    xrayDiagnosisResult,
    errorMessage,
    selectedBodyPartKey,
    selectedBodyPartLabel,
    selectedXrayImagePath,
    selectedXrayTitle,
  ];
}
