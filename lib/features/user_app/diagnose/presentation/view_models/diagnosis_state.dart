import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/diagnosis_result_model.dart';
import '../../data/models/question_model.dart';

// Represents the state of a data-fetching view
enum ViewState { idle, loading, success, error }

class DiagnosisState extends Equatable {
  // State for each process
  final ViewState categoryState;
  final ViewState questionState;
  final ViewState resultState;

  // Data
  final List<Category> categories;
  final List<Question> questions;
  final DiagnosisResult? diagnosisResult;
  final String errorMessage;

  // Current flow state
  final int? selectedCategoryId;
  final Map<int, int> answers; // <QuestionID, Answer (0 or 1)>

  const DiagnosisState({
    this.categoryState = ViewState.idle,
    this.questionState = ViewState.idle,
    this.resultState = ViewState.idle,
    this.categories = const [],
    this.questions = const [],
    this.diagnosisResult,
    this.errorMessage = '',
    this.selectedCategoryId,
    this.answers = const {},
  });

  // Factory for the initial state
  factory DiagnosisState.initial() => const DiagnosisState();

  // The 'copyWith' method is essential for emitting new states
  // It creates a new instance of the state, updating only the
  // fields that have changed.
  DiagnosisState copyWith({
    ViewState? categoryState,
    ViewState? questionState,
    ViewState? resultState,
    List<Category>? categories,
    List<Question>? questions,
    DiagnosisResult? diagnosisResult,
    String? errorMessage,
    int? selectedCategoryId,
    Map<int, int>? answers,
    bool clearDiagnosisResult = false, // Flag to explicitly set result to null
    bool clearSelectedCategory =
        false, // Flag to explicitly set category to null
  }) {
    return DiagnosisState(
      categoryState: categoryState ?? this.categoryState,
      questionState: questionState ?? this.questionState,
      resultState: resultState ?? this.resultState,
      categories: categories ?? this.categories,
      questions: questions ?? this.questions,
      diagnosisResult: clearDiagnosisResult
          ? null
          : diagnosisResult ?? this.diagnosisResult,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategoryId: clearSelectedCategory
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      answers: answers ?? this.answers,
    );
  }

  // Equatable props
  // This tells Equatable which fields to compare to check if
  // the state has actually changed.
  @override
  List<Object?> get props => [
    categoryState,
    questionState,
    resultState,
    categories,
    questions,
    diagnosisResult,
    errorMessage,
    selectedCategoryId,
    answers,
  ];
}
