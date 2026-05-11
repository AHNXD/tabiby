part of 'ai_usage_cubit.dart';

enum AiUsageAsyncStatus { idle, loading, success, error }

class AiUsageState extends Equatable {
  final AiUsageAsyncStatus remainingStatus;
  final AiUsageAsyncStatus consumeStatus;
  final Map<AiFeatureType, AiFeatureUsageLimit> remainingByFeature;
  final String errorMessage;

  const AiUsageState({
    this.remainingStatus = AiUsageAsyncStatus.idle,
    this.consumeStatus = AiUsageAsyncStatus.idle,
    this.remainingByFeature = const {},
    this.errorMessage = '',
  });

  AiUsageState copyWith({
    AiUsageAsyncStatus? remainingStatus,
    AiUsageAsyncStatus? consumeStatus,
    Map<AiFeatureType, AiFeatureUsageLimit>? remainingByFeature,
    String? errorMessage,
  }) {
    return AiUsageState(
      remainingStatus: remainingStatus ?? this.remainingStatus,
      consumeStatus: consumeStatus ?? this.consumeStatus,
      remainingByFeature: remainingByFeature ?? this.remainingByFeature,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    remainingStatus,
    consumeStatus,
    remainingByFeature,
    errorMessage,
  ];
}
