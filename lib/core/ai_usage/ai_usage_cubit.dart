import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ai_usage_models.dart';
import '../repos/ai_usage_repo.dart';

part 'ai_usage_state.dart';

class AiUsageCubit extends Cubit<AiUsageState> {
  AiUsageCubit(this._repo) : super(const AiUsageState());

  final AiUsageRepo _repo;

  Future<void> refreshRemaining({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(remainingStatus: AiUsageAsyncStatus.loading));
    }

    final result = await _repo.getRemaining();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            remainingStatus: AiUsageAsyncStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            remainingStatus: AiUsageAsyncStatus.success,
            remainingByFeature: response.remainingByFeature,
            errorMessage: '',
          ),
        );
      },
    );
  }

  AiFeatureUsageLimit? usageFor(AiFeatureType type) =>
      state.remainingByFeature[type];

  bool isFeatureBlocked(AiFeatureType type) {
    final usage = usageFor(type);
    if (usage == null) return false;
    return usage.remaining <= 0;
  }

  Future<bool> canNavigateToFeature(AiFeatureType type) async {
    if (state.remainingStatus != AiUsageAsyncStatus.success) {
      await refreshRemaining(silent: true);
    }

    final usage = usageFor(type);
    if (usage == null) return true;
    return usage.remaining > 0;
  }

  Future<bool> consumeFeature(AiFeatureType type) async {
    if (state.consumeStatus == AiUsageAsyncStatus.loading) return false;

    final currentUsage = usageFor(type);
    if (currentUsage != null && currentUsage.remaining <= 0) {
      emit(
        state.copyWith(
          consumeStatus: AiUsageAsyncStatus.error,
          errorMessage: 'ai_usage_limit_reached',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        consumeStatus: AiUsageAsyncStatus.loading,
        errorMessage: '',
      ),
    );

    final result = await _repo.useFeature(type);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            consumeStatus: AiUsageAsyncStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (response) {
        final updated = Map<AiFeatureType, AiFeatureUsageLimit>.from(
          state.remainingByFeature,
        );
        updated[response.featureType] = response.usage;

        if (response.isLimitReached) {
          emit(
            state.copyWith(
              consumeStatus: AiUsageAsyncStatus.error,
              remainingByFeature: Map.unmodifiable(updated),
              errorMessage: 'ai_usage_limit_reached',
            ),
          );
          return false;
        }

        emit(
          state.copyWith(
            consumeStatus: AiUsageAsyncStatus.success,
            remainingByFeature: Map.unmodifiable(updated),
            errorMessage: '',
          ),
        );

        return true;
      },
    );
  }
}
