import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/centers_query_params.dart';
import '../../../center_details/data/models/centers_model.dart';
import '../../data/repos/centers_repo.dart';

part 'centers_state.dart';

class CentersCubit extends Cubit<CentersState> {
  CentersCubit(this._centersRepo) : super(CentersInitial());

  final CentersRepo _centersRepo;

  int _page = 1;
  int _totalCount = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isRefreshing = false;
  CentersQueryParams _currentQuery = CentersQueryParams.empty;

  bool get isRefreshing => _isRefreshing;
  CentersQueryParams get currentQuery => _currentQuery;

  final List<Centers> _centers = [];

  Future<void> getCenters({
    bool loadMore = false,
    CentersQueryParams? queryParams,
  }) async {
    if (loadMore && (_isLoadingMore || !_hasMore)) return;

    if (queryParams != null) {
      _currentQuery = queryParams;
    }

    if (!loadMore) {
      _page = 1;
      _totalCount = 0;
      _centers.clear();
      _hasMore = true;
      emit(CentersLoading());
    } else {
      _isLoadingMore = true;
      emit(
        CentersSuccess(
          centers: List.from(_centers),
          totalCount: _totalCount,
          hasMore: _hasMore,
          isLoadingMore: true,
        ),
      );
    }

    final result = await _centersRepo.getCenters(_page, _currentQuery);

    result.fold(
      (failure) {
        _isLoadingMore = false;
        emit(CentersError(errorMsg: failure.message));
      },
      (data) {
        final pageInfo = data.pageInfo;

        _centers.addAll(data.centers ?? []);
        _totalCount = pageInfo?.total ?? _centers.length;
        _hasMore = pageInfo!.currentPage < pageInfo.lastPage;
        _page++;

        _isLoadingMore = false;

        emit(
          CentersSuccess(
            centers: List<Centers>.from(_centers),
            totalCount: _totalCount,
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
    _isLoadingMore = false;
  }

  Future<void> refreshCenters() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    _isLoadingMore = false;

    _page = 1;
    _totalCount = 0;
    _hasMore = true;
    _centers.clear();

    emit(CentersLoading());

    final result = await _centersRepo.getCenters(_page, _currentQuery);

    result.fold(
      (failure) {
        _isRefreshing = false;
        emit(CentersError(errorMsg: failure.message));
      },
      (data) {
        _centers.addAll(data.centers ?? []);

        final pageInfo = data.pageInfo!;
        _totalCount = pageInfo.total;
        _hasMore = pageInfo.currentPage < pageInfo.lastPage;
        _page++;

        _isRefreshing = false;

        emit(
          CentersSuccess(
            centers: List.from(_centers),
            totalCount: _totalCount,
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
