part of 'center_cubit.dart';

sealed class CenterState extends Equatable {
  const CenterState();

  @override
  List<Object> get props => [];
}

final class CenterInitial extends CenterState {}

final class CenterLoading extends CenterState {}

final class CenterError extends CenterState {
  final String errorMsg;

  const CenterError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class CenterSuccess extends CenterState {
  final Centers center;
  const CenterSuccess({required this.center});
  @override
  List<Object> get props => [center];
}
