part of 'doctor_cubit.dart';

sealed class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object> get props => [];
}

final class DoctorsInitial extends DoctorsState {}

final class DoctorsLoading extends DoctorsState {}

final class DoctorsError extends DoctorsState {
  final String errorMsg;

  const DoctorsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class DoctorsSuccess extends DoctorsState {
  final DoctorsModel doctors;
  const DoctorsSuccess({required this.doctors});
  @override
  List<Object> get props => [doctors];
}
