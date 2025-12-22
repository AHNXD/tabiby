import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo.dart';

import 'booking_state.dart';

// booking_cubit.dart
class BookingCubit extends Cubit<BookingState> {
  final AddAppoinmentRepo _addAppoinmentRepo;
  final int doctorId;

  BookingCubit(this._addAppoinmentRepo, this.doctorId)
    : super(BookingInitial());

  // 1. Initial Load: Get Centers
  Future<void> fetchCenters() async {
    emit(BookingLoading());
    var result = await _addAppoinmentRepo.getCenters(doctorId);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (centers) => emit(BookingSuccess(centers: centers)),
    );
  }

  // 2. Select Center -> Fetch Days
  Future<void> selectCenter(int centerId) async {
    if (state is! BookingSuccess) return;
    final currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedCenterId: centerId,
        isLoadingDays: true,
        days: [], // Reset days and times
        times: null,
        selectedDate: null,
        selectedTime: null,
      ),
    );

    var result = await _addAppoinmentRepo.getDays(doctorId, centerId);
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (days) => emit(
        (state as BookingSuccess).copyWith(days: days, isLoadingDays: false),
      ),
    );
  }

  // 3. Select Day -> Fetch Times
  Future<void> selectDay(String date) async {
    if (state is! BookingSuccess) return;
    final currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedDate: date,
        isLoadingTimes: true,
        times: null,
        selectedTime: null,
      ),
    );

    var result = await _addAppoinmentRepo.getTimes(
      doctorId,
      currentState.selectedCenterId,
      date,
    );
    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (times) => emit(
        (state as BookingSuccess).copyWith(times: times, isLoadingTimes: false),
      ),
    );
  }

  void selectTime(String time, String periodName) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(
        selectedTime: time,
        selectedPeriodName: periodName,
      ),
    );
  }

  Future<void> bookAppointment(String note) async {
    if (state is! BookingSuccess) return;
    final s = state as BookingSuccess;

    if (s.selectedCenterId == null ||
        s.selectedDate == null ||
        s.selectedTime == null) {
      return;
    }

    emit(s.copyWith(isBooking: true));
    var result = await _addAppoinmentRepo.bookAppointment(
      doctorId.toString(),
      s.selectedCenterId.toString(),
      s.selectedDate!,
      s.selectedPeriodName!,
      s.selectedTime!,
      note,
    );

    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (success) => emit(AppointmentBookedSuccessfully()),
    );
  }
}
