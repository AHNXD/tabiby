import '../../data/models/centers_appointment_model.dart';
import '../../data/models/days_model.dart';
import '../../data/models/times_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingFailure extends BookingState {
  final String errMessage;
  BookingFailure(this.errMessage);
}

class BookingSuccess extends BookingState {
  final List<Centers> centers;
  final List<Days> days;
  final TimesModel? times;

  final int? selectedCenterId;
  final String? selectedDate;
  final String? selectedTime;

  final String? selectedPeriodName;

  // Flags to show loading for specific sectsions
  final bool isLoadingDays;
  final bool isLoadingTimes;
  final bool isBooking;

  BookingSuccess({
    required this.centers,
    this.days = const [],
    this.times,
    this.selectedCenterId,
    this.selectedDate,
    this.selectedTime,
    this.selectedPeriodName,
    this.isLoadingDays = false,
    this.isLoadingTimes = false,
    this.isBooking = false,
  });

  BookingSuccess copyWith({
    List<Centers>? centers,
    List<Days>? days,
    TimesModel? times,
    int? selectedCenterId,
    String? selectedDate,
    String? selectedTime,
    String? selectedPeriodName,
    bool? isLoadingDays,
    bool? isLoadingTimes,
    bool? isBooking,
  }) {
    return BookingSuccess(
      centers: centers ?? this.centers,
      days: days ?? this.days,
      times: times ?? this.times,
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPeriodName: selectedPeriodName ?? this.selectedPeriodName,
      isLoadingDays: isLoadingDays ?? false,
      isLoadingTimes: isLoadingTimes ?? false,
      isBooking: isBooking ?? false,
    );
  }
}

class AppointmentBookedSuccessfully extends BookingState {}
