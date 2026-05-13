import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/diet_plan_history_item.dart';
import '../../data/models/diet_plan_response.dart';
import '../../data/models/diet_request_data.dart';
import '../../data/models/paginated_diet_plans_result.dart';
import '../../data/repos/diet_repository.dart';

part 'diet_state.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit(this._dietRepository) : super(const DietState()) {
    loadHistory();
  }

  final DietRepository _dietRepository;
  int _sessionVersion = 0;

  Future<void> generateDietPlan(DietRequestData request) async {
    final int sessionVersion = _sessionVersion;
    emit(
      state.copyWith(
        submitStatus: DietAsyncStatus.loading,
        currentRequest: request,
        errorMessage: '',
        infoMessage: 'diet_generation_takes_time',
        exportStatus: DietAsyncStatus.initial,
        exportErrorMessage: '',
        clearExportPdfBytes: true,
      ),
    );

    final result = await _dietRepository.generateDietPlan(request);
    if (sessionVersion != _sessionVersion) {
      return;
    }

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            submitStatus: DietAsyncStatus.error,
            errorMessage: failure.message,
            infoMessage: '',
          ),
        );
      },
      (item) async {
        final updatedHistory = _upsertHistoryItem(item);

        emit(
          state.copyWith(
            submitStatus: DietAsyncStatus.success,
            historyStatus: DietAsyncStatus.success,
            planStatus: DietAsyncStatus.success,
            plan: item.plan,
            currentRequest: item.request,
            history: updatedHistory,
            currentPlanId: item.id,
            currentPlanCreatedAt: item.createdAt,
            errorMessage: '',
            infoMessage: '',
          ),
        );
      },
    );
  }

  Future<void> loadHistory() async {
    final int sessionVersion = _sessionVersion;
    emit(
      state.copyWith(historyStatus: DietAsyncStatus.loading, errorMessage: ''),
    );

    final result = await _dietRepository.getDietPlans();
    if (sessionVersion != _sessionVersion) {
      return;
    }

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            historyStatus: DietAsyncStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (historyResult) {
        emit(
          state.copyWith(
            historyStatus: DietAsyncStatus.success,
            history: historyResult.items,
            historyMeta: historyResult.meta,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<bool> openHistoryItem(DietPlanHistoryItem item) async {
    final int sessionVersion = _sessionVersion;
    emit(
      state.copyWith(
        planStatus: DietAsyncStatus.loading,
        errorMessage: '',
        infoMessage: '',
        exportStatus: DietAsyncStatus.initial,
        exportErrorMessage: '',
        clearExportPdfBytes: true,
      ),
    );

    final result = await _dietRepository.getDietPlanById(item.id);
    if (sessionVersion != _sessionVersion) {
      return false;
    }

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            planStatus: DietAsyncStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (savedItem) {
        emit(
          state.copyWith(
            planStatus: DietAsyncStatus.success,
            plan: savedItem.plan,
            currentRequest: savedItem.request,
            history: _upsertHistoryItem(savedItem),
            currentPlanId: savedItem.id,
            currentPlanCreatedAt: savedItem.createdAt,
            errorMessage: '',
          ),
        );
        return true;
      },
    );
  }

  Future<bool> openLatestPlan() async {
    final int sessionVersion = _sessionVersion;
    emit(
      state.copyWith(
        planStatus: DietAsyncStatus.loading,
        errorMessage: '',
        infoMessage: '',
        exportStatus: DietAsyncStatus.initial,
        exportErrorMessage: '',
        clearExportPdfBytes: true,
      ),
    );

    final result = await _dietRepository.getLatestDietPlan();
    if (sessionVersion != _sessionVersion) {
      return false;
    }

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            planStatus: DietAsyncStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (item) {
        emit(
          state.copyWith(
            planStatus: DietAsyncStatus.success,
            historyStatus: DietAsyncStatus.success,
            plan: item.plan,
            currentRequest: item.request,
            history: _upsertHistoryItem(item),
            currentPlanId: item.id,
            currentPlanCreatedAt: item.createdAt,
            errorMessage: '',
          ),
        );
        return true;
      },
    );
  }

  void setCurrentRequest(DietRequestData request) {
    emit(state.copyWith(currentRequest: request));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: '', infoMessage: ''));
  }

  void reset() {
    _sessionVersion++;
    emit(
      state.copyWith(
        submitStatus: DietAsyncStatus.initial,
        historyStatus: DietAsyncStatus.initial,
        planStatus: DietAsyncStatus.initial,
        errorMessage: '',
        infoMessage: '',
        history: const <DietPlanHistoryItem>[],
        historyMeta: const DietPlansMeta(page: 1, limit: 10, total: 0),
        clearPlan: true,
        clearCurrentRequest: true,
        currentPlanId: '',
        clearCurrentPlanCreatedAt: true,
        exportStatus: DietAsyncStatus.initial,
        exportErrorMessage: '',
        clearExportPdfBytes: true,
      ),
    );
  }

  Future<void> exportCurrentPlanAsPdf() async {
    final int sessionVersion = _sessionVersion;
    final DietPlanResponse? plan = state.plan;
    final DietRequestData? request = state.currentRequest;

    if (plan == null || request == null) {
      emit(
        state.copyWith(
          exportStatus: DietAsyncStatus.error,
          exportErrorMessage: 'diet_export_pdf_missing_plan',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        exportStatus: DietAsyncStatus.loading,
        exportErrorMessage: '',
        clearExportPdfBytes: true,
      ),
    );

    final result = await _dietRepository.exportDietPlanAsPdf(
      plan: plan,
      request: request,
      createdAt: state.currentPlanCreatedAt,
    );
    if (sessionVersion != _sessionVersion) {
      return;
    }

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            exportStatus: DietAsyncStatus.error,
            exportErrorMessage: failure.message,
          ),
        );
      },
      (Uint8List bytes) {
        final String fileName =
            'diet_plan_${state.currentPlanId.isEmpty ? "export" : state.currentPlanId}.pdf';
        emit(
          state.copyWith(
            exportStatus: DietAsyncStatus.success,
            exportPdfBytes: bytes,
            exportFileName: fileName,
            exportErrorMessage: '',
          ),
        );
      },
    );
  }

  void clearExport() {
    emit(
      state.copyWith(
        exportStatus: DietAsyncStatus.initial,
        exportErrorMessage: '',
        exportFileName: '',
        clearExportPdfBytes: true,
      ),
    );
  }

  List<DietPlanHistoryItem> _upsertHistoryItem(DietPlanHistoryItem item) {
    final updatedHistory = List<DietPlanHistoryItem>.from(state.history)
      ..removeWhere((existingItem) => existingItem.id == item.id)
      ..insert(0, item);

    return updatedHistory;
  }
}
