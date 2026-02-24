import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/cache_helper.dart';

import '../../data/models/diet_plan_history_item.dart';
import '../../data/models/diet_plan_response.dart';
import '../../data/models/diet_request_data.dart';
import '../../data/repos/diet_repository.dart';

part 'diet_state.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit(this._dietRepository) : super(const DietState()) {
    loadHistory();
  }

  final DietRepository _dietRepository;

  static const String _historyCacheKey = 'diet_plan_history_v1';
  static const int _maxHistoryItems = 20;

  Future<void> generateDietPlan(DietRequestData request) async {
    emit(
      state.copyWith(
        viewState: DietViewState.loading,
        currentRequest: request,
        errorMessage: '',
        infoMessage: 'diet_generation_takes_time',
      ),
    );

    final result = await _dietRepository.generateDietPlan(request);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            viewState: DietViewState.error,
            errorMessage: failure.message,
            infoMessage: '',
          ),
        );
      },
      (plan) async {
        final newItem = DietPlanHistoryItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          request: request,
          plan: plan,
        );

        final updatedHistory = [
          newItem,
          ...state.history,
        ].take(_maxHistoryItems).toList();

        await _persistHistory(updatedHistory);

        emit(
          state.copyWith(
            viewState: DietViewState.success,
            plan: plan,
            currentRequest: request,
            history: updatedHistory,
            errorMessage: '',
            infoMessage: '',
          ),
        );
      },
    );
  }

  Future<void> loadHistory() async {
    try {
      final raw = CacheHelper.getData(key: _historyCacheKey);
      if (raw is! String || raw.trim().isEmpty) {
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return;
      }

      final history = decoded
          .whereType<Map>()
          .map(
            (item) =>
                DietPlanHistoryItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      if (history.isEmpty) {
        return;
      }

      emit(
        state.copyWith(
          history: history,
          plan: state.plan ?? history.first.plan,
          currentRequest: state.currentRequest ?? history.first.request,
        ),
      );
    } catch (_) {}
  }

  void openHistoryItem(DietPlanHistoryItem item) {
    emit(
      state.copyWith(
        viewState: DietViewState.success,
        plan: item.plan,
        currentRequest: item.request,
        errorMessage: '',
        infoMessage: '',
      ),
    );
  }

  void setCurrentRequest(DietRequestData request) {
    emit(state.copyWith(currentRequest: request));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: '', infoMessage: ''));
  }

  void reset() {
    emit(
      state.copyWith(
        viewState: DietViewState.idle,
        errorMessage: '',
        infoMessage: '',
        clearPlan: true,
        clearCurrentRequest: true,
      ),
    );
  }

  Future<void> _persistHistory(List<DietPlanHistoryItem> history) async {
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await CacheHelper.setString(key: _historyCacheKey, value: encoded);
  }
}
