import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/rating_status_model.dart';
import '../../../data/repos/rating/rating_repo.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit(this._ratingRepo) : super(RatingInitial());

  final RatingRepo _ratingRepo;

  Future<void> checkAppointment(int id) async {
    emit(RatingCheckLoading());
    final result = await _ratingRepo.checkAppointment(id);

    result.fold(
      (failure) => emit(RatingCheckError(errorMsg: failure.message)),
      (status) => emit(RatingCheckLoaded(status)),
    );
  }

  Future addRate(int id, int rate, String comment) async {
    emit(RatingLoading());
    var data = await _ratingRepo.addRate(id, rate, comment);
    data.fold((failure) => emit(RatingError(errorMsg: failure.message)), (
      result,
    ) {
      emit(RatingSuccess());
    });
  }
}
