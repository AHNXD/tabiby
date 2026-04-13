import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/doctors/data/repos/doctors_repo.dart';

import '../../data/models/doctors_query_params.dart';
import '../../../doctor_details/data/models/doctor_model.dart';

part 'doctor_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this._doctorsRepo) : super(DoctorsInitial());

  final DoctorsRepo _doctorsRepo;
  int _page = 1;
  int _totalCount = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isRefreshing = false;
  DoctorsQueryParams _currentQuery = DoctorsQueryParams.empty;

  bool get isRefreshing => _isRefreshing;
  DoctorsQueryParams get currentQuery => _currentQuery;

  final List<Doctor> _doctors = [];

  Future<void> getDoctors(
    int? centerID,
    int? specialtyID, {
    bool loadMore = false,
    DoctorsQueryParams? queryParams,
  }) async {
    if (loadMore && (_isLoadingMore || !_hasMore)) return;

    if (queryParams != null) {
      _currentQuery = queryParams;
    }

    if (!loadMore) {
      _page = 1;
      _totalCount = 0;
      _doctors.clear();
      _hasMore = true;
      emit(DoctorsLoading());
    } else {
      _isLoadingMore = true;
      emit(
        DoctorsSuccess(
          doctors: List.from(_doctors),
          totalCount: _totalCount,
          hasMore: _hasMore,
          isLoadingMore: true,
        ),
      );
    }

    final result = await _doctorsRepo.getDoctors(
      centerID,
      specialtyID,
      _page,
      _currentQuery,
    );

    result.fold(
      (failure) {
        _isLoadingMore = false;
        emit(DoctorsError(errorMsg: failure.message));
      },
      (data) {
        final pageInfo = data.pageInfo;

        _doctors.addAll(data.doctors ?? []);

        _totalCount = pageInfo?.total ?? _doctors.length;
        _hasMore = pageInfo!.currentPage < pageInfo.lastPage;
        _page++;

        _isLoadingMore = false;

        emit(
          DoctorsSuccess(
            doctors: List<Doctor>.from(_doctors),
            totalCount: _totalCount,
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );

    _isLoadingMore = false;
  }

  Future<void> refreshDoctors(int? centerID, int? specialtyID) async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    _isLoadingMore = false;

    _page = 1;
    _totalCount = 0;
    _hasMore = true;
    _doctors.clear();

    emit(DoctorsLoading());

    final result = await _doctorsRepo.getDoctors(
      centerID,
      specialtyID,
      _page,
      _currentQuery,
    );

    result.fold(
      (failure) {
        _isRefreshing = false;
        emit(DoctorsError(errorMsg: failure.message));
      },
      (data) {
        _doctors.addAll(data.doctors ?? []);

        final pageInfo = data.pageInfo!;
        _totalCount = pageInfo.total;
        _hasMore = pageInfo.currentPage < pageInfo.lastPage;
        _page++;

        _isRefreshing = false;

        emit(
          DoctorsSuccess(
            doctors: List.from(_doctors),
            totalCount: _totalCount,
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
