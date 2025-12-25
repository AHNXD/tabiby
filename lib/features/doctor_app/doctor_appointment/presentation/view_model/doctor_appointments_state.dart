part of 'doctor_appoinements_cubit.dart';

sealed class DoctorsAppointmentsState extends Equatable {
  const DoctorsAppointmentsState();

  @override
  List<Object> get props => [];
}

final class DoctorsAppointmentInitial extends DoctorsAppointmentsState {}

final class DoctorsAppointmentLoading extends DoctorsAppointmentsState {}

final class DoctorsAppointmentError extends DoctorsAppointmentsState {
  final String errorMsg;

  const DoctorsAppointmentError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class DoctorsAppointmentSuccess extends DoctorsAppointmentsState {
  final DoctorAppointmentsModel doctorsAppointment;
  const DoctorsAppointmentSuccess({required this.doctorsAppointment});
  @override
  List<Object> get props => [doctorsAppointment];
}
