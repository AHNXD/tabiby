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
  final List<Centers> centers;
  final bool hasMore;
  final bool isLoadingMore;
  const CentersSuccess({
    required this.centers,
    required this.hasMore,
    required this.isLoadingMore,
  });
  @override
  List<Object> get props => [centers, hasMore, isLoadingMore];
}
