part of 'doctor_appoinement_details_cubit.dart';

sealed class DoctorsAppointmentDetailsState extends Equatable {
  const DoctorsAppointmentDetailsState();

  @override
  List<Object> get props => [];
}

final class DoctorsAppointmentDetailsInitial extends DoctorsAppointmentDetailsState {}

final class DoctorsAppointmentDetailsLoading extends DoctorsAppointmentDetailsState {}

final class DoctorsAppointmentDetailsError extends DoctorsAppointmentDetailsState {
  final String errorMsg;

  const DoctorsAppointmentDetailsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class DoctorAppointmentDetailsSuccess extends DoctorsAppointmentDetailsState {
  final DoctorAppointmentDetailsModel doctorsAppointmentDetails;
  const DoctorAppointmentDetailsSuccess({required this.doctorsAppointmentDetails});
  @override
  List<Object> get props => [doctorsAppointmentDetails];
}
