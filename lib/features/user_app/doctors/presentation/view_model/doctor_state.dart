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
  final List<Doctor> doctors;
  final bool hasMore;
  final bool isLoadingMore;
  const DoctorsSuccess({
    required this.doctors,
    required this.hasMore,
    required this.isLoadingMore,
  });
  @override
  List<Object> get props => [doctors, hasMore, isLoadingMore];
}
