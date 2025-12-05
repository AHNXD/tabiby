part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {
  final String errorMsg;

  const HomeError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class HomeSuccess extends HomeState {
  final HomeModel home;

  const HomeSuccess({required this.home});
  @override
  List<Object> get props => [home];
}
