part of 'ai_usage_cubit.dart';

enum AiUsageAsyncStatus { idle, loading, success, error }

class AiUsageState extends Equatable {
  final AiUsageAsyncStatus remainingStatus;
  final Map<AiFeatureType, AiFeatureUsageLimit> remainingByFeature;
  final String errorMessage;

  const AiUsageState({
    this.remainingStatus = AiUsageAsyncStatus.idle,
    this.remainingByFeature = const {},
    this.errorMessage = '',
  });

  AiUsageState copyWith({
    AiUsageAsyncStatus? remainingStatus,
    Map<AiFeatureType, AiFeatureUsageLimit>? remainingByFeature,
    String? errorMessage,
  }) {
    return AiUsageState(
      remainingStatus: remainingStatus ?? this.remainingStatus,
      remainingByFeature: remainingByFeature ?? this.remainingByFeature,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    remainingStatus,
    remainingByFeature,
    errorMessage,
  ];
}
