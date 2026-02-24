import 'package:equatable/equatable.dart';

import '../../data/models/diagnosis_result_model.dart';
import '../../data/models/symptom_model.dart';

enum ViewState { idle, loading, success, error }

class DiagnosisState extends Equatable {
  final ViewState symptomsState;
  final ViewState resultState;
  final List<Symptom> symptoms;
  final DiagnosisResult? diagnosisResult;
  final String errorMessage;
  final String? selectedBodyPartKey;
  final String? selectedBodyPartLabel;

  const DiagnosisState({
    this.symptomsState = ViewState.idle,
    this.resultState = ViewState.idle,
    this.symptoms = const [],
    this.diagnosisResult,
    this.errorMessage = '',
    this.selectedBodyPartKey,
    this.selectedBodyPartLabel,
  });

  factory DiagnosisState.initial() => const DiagnosisState();

  DiagnosisState copyWith({
    ViewState? symptomsState,
    ViewState? resultState,
    List<Symptom>? symptoms,
    DiagnosisResult? diagnosisResult,
    String? errorMessage,
    String? selectedBodyPartKey,
    String? selectedBodyPartLabel,
    bool clearSymptoms = false,
    bool clearDiagnosisResult = false,
    bool clearSelectedBodyPart = false,
  }) {
    return DiagnosisState(
      symptomsState: symptomsState ?? this.symptomsState,
      resultState: resultState ?? this.resultState,
      symptoms: clearSymptoms ? const [] : symptoms ?? this.symptoms,
      diagnosisResult: clearDiagnosisResult
          ? null
          : diagnosisResult ?? this.diagnosisResult,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBodyPartKey: clearSelectedBodyPart
          ? null
          : selectedBodyPartKey ?? this.selectedBodyPartKey,
      selectedBodyPartLabel: clearSelectedBodyPart
          ? null
          : selectedBodyPartLabel ?? this.selectedBodyPartLabel,
    );
  }

  List<Symptom> get selectedSymptoms =>
      symptoms.where((symptom) => symptom.isSelected).toList();

  @override
  List<Object?> get props => [
    symptomsState,
    resultState,
    symptoms,
    diagnosisResult,
    errorMessage,
    selectedBodyPartKey,
    selectedBodyPartLabel,
  ];
}
