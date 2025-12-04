part of 'specialties_cubit.dart';

sealed class SpecialtiesState extends Equatable {
  const SpecialtiesState();

  @override
  List<Object> get props => [];
}

final class SpecialtiesInitial extends SpecialtiesState {}

final class SpecialtiesLoading extends SpecialtiesState {}

final class SpecialtiesError extends SpecialtiesState {
  final String errorMsg;

  const SpecialtiesError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class SpecialtiesSuccess extends SpecialtiesState {
  final SpecialtiesModel specialties;

  const SpecialtiesSuccess({required this.specialties});
  @override
  List<Object> get props => [specialties];
}
