part of 'diet_cubit.dart';

enum DietAsyncStatus { initial, loading, success, error }

class DietState extends Equatable {
  const DietState({
    this.submitStatus = DietAsyncStatus.initial,
    this.historyStatus = DietAsyncStatus.initial,
    this.planStatus = DietAsyncStatus.initial,
    this.exportStatus = DietAsyncStatus.initial,
    this.plan,
    this.currentRequest,
    this.currentPlanId = '',
    this.currentPlanCreatedAt,
    this.history = const [],
    this.historyMeta = const DietPlansMeta(page: 1, limit: 10, total: 0),
    this.errorMessage = '',
    this.infoMessage = '',
    this.exportPdfBytes,
    this.exportFileName = '',
    this.exportErrorMessage = '',
  });

  final DietAsyncStatus submitStatus;
  final DietAsyncStatus historyStatus;
  final DietAsyncStatus planStatus;
  final DietAsyncStatus exportStatus;
  final DietPlanResponse? plan;
  final DietRequestData? currentRequest;
  final String currentPlanId;
  final DateTime? currentPlanCreatedAt;
  final List<DietPlanHistoryItem> history;
  final DietPlansMeta historyMeta;
  final String errorMessage;
  final String infoMessage;
  final Uint8List? exportPdfBytes;
  final String exportFileName;
  final String exportErrorMessage;

  bool get isLoading => isGenerating;
  bool get isGenerating => submitStatus == DietAsyncStatus.loading;
  bool get isLoadingHistory => historyStatus == DietAsyncStatus.loading;
  bool get isLoadingPlan => planStatus == DietAsyncStatus.loading;
  bool get isExporting => exportStatus == DietAsyncStatus.loading;

  DietState copyWith({
    DietAsyncStatus? submitStatus,
    DietAsyncStatus? historyStatus,
    DietAsyncStatus? planStatus,
    DietAsyncStatus? exportStatus,
    DietPlanResponse? plan,
    DietRequestData? currentRequest,
    String? currentPlanId,
    DateTime? currentPlanCreatedAt,
    List<DietPlanHistoryItem>? history,
    DietPlansMeta? historyMeta,
    String? errorMessage,
    String? infoMessage,
    Uint8List? exportPdfBytes,
    String? exportFileName,
    String? exportErrorMessage,
    bool clearPlan = false,
    bool clearCurrentRequest = false,
    bool clearExportPdfBytes = false,
    bool clearCurrentPlanCreatedAt = false,
  }) {
    return DietState(
      submitStatus: submitStatus ?? this.submitStatus,
      historyStatus: historyStatus ?? this.historyStatus,
      planStatus: planStatus ?? this.planStatus,
      exportStatus: exportStatus ?? this.exportStatus,
      plan: clearPlan ? null : plan ?? this.plan,
      currentRequest: clearCurrentRequest
          ? null
          : currentRequest ?? this.currentRequest,
      currentPlanId: currentPlanId ?? this.currentPlanId,
      currentPlanCreatedAt: clearCurrentPlanCreatedAt
          ? null
          : currentPlanCreatedAt ?? this.currentPlanCreatedAt,
      history: history ?? this.history,
      historyMeta: historyMeta ?? this.historyMeta,
      errorMessage: errorMessage ?? this.errorMessage,
      infoMessage: infoMessage ?? this.infoMessage,
      exportPdfBytes: clearExportPdfBytes
          ? null
          : exportPdfBytes ?? this.exportPdfBytes,
      exportFileName: exportFileName ?? this.exportFileName,
      exportErrorMessage: exportErrorMessage ?? this.exportErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    submitStatus,
    historyStatus,
    planStatus,
    exportStatus,
    plan,
    currentRequest,
    currentPlanId,
    currentPlanCreatedAt,
    history,
    historyMeta,
    errorMessage,
    infoMessage,
    exportPdfBytes,
    exportFileName,
    exportErrorMessage,
  ];
}
