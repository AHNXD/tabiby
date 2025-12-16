part of 'doctor_details_cubit.dart';

sealed class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object> get props => [];
}

final class DoctorDetailsInitial extends DoctorDetailsState {}

final class DoctorDetailsLoading extends DoctorDetailsState {}

final class DoctorDetailsError extends DoctorDetailsState {
  final String errorMsg;

  const DoctorDetailsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class DoctorDetailsSuccess extends DoctorDetailsState {
  final Doctor doctor;
  const DoctorDetailsSuccess({required this.doctor});
  @override
  List<Object> get props => [doctor];
}
