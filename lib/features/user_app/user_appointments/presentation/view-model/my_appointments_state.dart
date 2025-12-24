part of 'my_appointments_cubit.dart';

sealed class MyAppointmentsState extends Equatable {
  const MyAppointmentsState();

  @override
  List<Object> get props => [];
}

final class MyAppointmentsInitial extends MyAppointmentsState {}

final class MyAppointmentsoading extends MyAppointmentsState {}

final class MyAppointmentsError extends MyAppointmentsState {
  final String errorMsg;

  const MyAppointmentsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class MyAppointmentsSuccess extends MyAppointmentsState {
  final Appointments myAppointments;

  const MyAppointmentsSuccess({required this.myAppointments});
  @override
  List<Object> get props => [myAppointments];
}
