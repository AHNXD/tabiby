part of 'appointment_details_cubit.dart';

sealed class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class AppointmentDetailsInitial extends AppointmentDetailsState {}

final class AppointmentDetailsLoading extends AppointmentDetailsState {}

final class AppointmentDetailsError extends AppointmentDetailsState {
  const AppointmentDetailsError({required this.errorMsg});

  final String errorMsg;

  @override
  List<Object?> get props => <Object?>[errorMsg];
}

final class AppointmentDetailsSuccess extends AppointmentDetailsState {
  const AppointmentDetailsSuccess({required this.details});

  final AppointmentDetailsModel details;

  @override
  List<Object?> get props => <Object?>[details];
}
