part of 'centers_cubit.dart';

sealed class CentersState extends Equatable {
  const CentersState();

  @override
  List<Object> get props => [];
}

final class CentersInitial extends CentersState {}

final class CentersLoading extends CentersState {}

final class CentersError extends CentersState {
  final String errorMsg;

  const CentersError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class CentersSuccess extends CentersState {
  final CentersModel centers;
  const CentersSuccess({required this.centers});
  @override
  List<Object> get props => [centers];
}
