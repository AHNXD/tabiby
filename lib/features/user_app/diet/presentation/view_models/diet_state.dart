part of 'diet_cubit.dart';

enum DietViewState { idle, loading, success, error }

class DietState extends Equatable {
  const DietState({
    this.viewState = DietViewState.idle,
    this.plan,
    this.currentRequest,
    this.history = const [],
    this.errorMessage = '',
    this.infoMessage = '',
  });

  final DietViewState viewState;
  final DietPlanResponse? plan;
  final DietRequestData? currentRequest;
  final List<DietPlanHistoryItem> history;
  final String errorMessage;
  final String infoMessage;

  bool get isLoading => viewState == DietViewState.loading;

  DietState copyWith({
    DietViewState? viewState,
    DietPlanResponse? plan,
    DietRequestData? currentRequest,
    List<DietPlanHistoryItem>? history,
    String? errorMessage,
    String? infoMessage,
    bool clearPlan = false,
    bool clearCurrentRequest = false,
  }) {
    return DietState(
      viewState: viewState ?? this.viewState,
      plan: clearPlan ? null : plan ?? this.plan,
      currentRequest: clearCurrentRequest
          ? null
          : currentRequest ?? this.currentRequest,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
      infoMessage: infoMessage ?? this.infoMessage,
    );
  }

  @override
  List<Object?> get props => [
    viewState,
    plan,
    currentRequest,
    history,
    errorMessage,
    infoMessage,
  ];
}
