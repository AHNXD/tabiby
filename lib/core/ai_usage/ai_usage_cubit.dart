import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ai_usage_models.dart';
import '../repos/ai_usage_repo.dart';

part 'ai_usage_state.dart';

class AiUsageCubit extends Cubit<AiUsageState> {
  AiUsageCubit(this._repo) : super(const AiUsageState());

  final AiUsageRepo _repo;
  int _sessionVersion = 0;

  Future<void> refreshRemaining({bool silent = false}) async {
    final int sessionVersion = _sessionVersion;
    if (!silent) {
      emit(state.copyWith(remainingStatus: AiUsageAsyncStatus.loading));
    }

    final result = await _repo.getRemaining();
    if (sessionVersion != _sessionVersion) {
      return;
    }

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

  void reset() {
    _sessionVersion++;
    emit(const AiUsageState());
  }
}
