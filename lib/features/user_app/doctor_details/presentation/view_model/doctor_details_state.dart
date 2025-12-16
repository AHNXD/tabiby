part of 'doctor_details_cubit.dart';

sealed class DoctorsDetailsState extends Equatable {
  const DoctorsDetailsState();

  @override
  List<Object> get props => [];
}

final class DoctorsDetailsInitial extends DoctorsDetailsState {}

final class DoctorsDetailsLoading extends DoctorsDetailsState {}

final class DoctorsDetailsError extends DoctorsDetailsState {
  final String errorMsg;

  const DoctorsDetailsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class DoctorsDetailsSuccess extends DoctorsDetailsState {
  final DoctorsModel doctors;
  const DoctorsDetailsSuccess({required this.doctors});
  @override
  List<Object> get props => [doctors];
}
