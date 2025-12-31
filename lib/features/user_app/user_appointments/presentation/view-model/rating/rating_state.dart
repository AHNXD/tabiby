part of 'rating_cubit.dart';

sealed class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

final class RatingInitial extends RatingState {}

final class RatingLoading extends RatingState {}

final class RatingError extends RatingState {
  final String errorMsg;

  const RatingError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class RatingSuccess extends RatingState {}

//check

final class RatingCheckLoading extends RatingState {}

final class RatingCheckLoaded extends RatingState {
  final RatingStatus ratingStatus;

  const RatingCheckLoaded(this.ratingStatus);

  @override
  List<Object> get props => [ratingStatus];
}

final class RatingCheckError extends RatingState {
  final String errorMsg;
  const RatingCheckError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
