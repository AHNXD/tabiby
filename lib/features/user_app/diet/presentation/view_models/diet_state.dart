part of 'diet_cubit.dart';

enum DietAsyncStatus { initial, loading, success, error }

class DietState extends Equatable {
  const DietState({
    this.submitStatus = DietAsyncStatus.initial,
    this.historyStatus = DietAsyncStatus.initial,
    this.planStatus = DietAsyncStatus.initial,
    this.plan,
    this.currentRequest,
    this.history = const [],
    this.historyMeta = const DietPlansMeta(page: 1, limit: 10, total: 0),
    this.errorMessage = '',
    this.infoMessage = '',
  });

  final DietAsyncStatus submitStatus;
  final DietAsyncStatus historyStatus;
  final DietAsyncStatus planStatus;
  final DietPlanResponse? plan;
  final DietRequestData? currentRequest;
  final List<DietPlanHistoryItem> history;
  final DietPlansMeta historyMeta;
  final String errorMessage;
  final String infoMessage;

  bool get isLoading => isGenerating;
  bool get isGenerating => submitStatus == DietAsyncStatus.loading;
  bool get isLoadingHistory => historyStatus == DietAsyncStatus.loading;
  bool get isLoadingPlan => planStatus == DietAsyncStatus.loading;

  DietState copyWith({
    DietAsyncStatus? submitStatus,
    DietAsyncStatus? historyStatus,
    DietAsyncStatus? planStatus,
    DietPlanResponse? plan,
    DietRequestData? currentRequest,
    List<DietPlanHistoryItem>? history,
    DietPlansMeta? historyMeta,
    String? errorMessage,
    String? infoMessage,
    bool clearPlan = false,
    bool clearCurrentRequest = false,
  }) {
    return DietState(
      submitStatus: submitStatus ?? this.submitStatus,
      historyStatus: historyStatus ?? this.historyStatus,
      planStatus: planStatus ?? this.planStatus,
      plan: clearPlan ? null : plan ?? this.plan,
      currentRequest: clearCurrentRequest
          ? null
          : currentRequest ?? this.currentRequest,
      history: history ?? this.history,
      historyMeta: historyMeta ?? this.historyMeta,
      errorMessage: errorMessage ?? this.errorMessage,
      infoMessage: infoMessage ?? this.infoMessage,
    );
  }

  @override
  List<Object?> get props => [
    submitStatus,
    historyStatus,
    planStatus,
    plan,
    currentRequest,
    history,
    historyMeta,
    errorMessage,
    infoMessage,
  ];
}
