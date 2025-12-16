import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../center_details/data/models/centers_model.dart';
import '../../../centers/data/repos/centers_repo.dart';

part 'center_state.dart';

class CenterCubit extends Cubit<CenterState> {
  CenterCubit(this._centersRepo) : super(CenterInitial());

  final CentersRepo _centersRepo;

  Future getCenter(int centerID) async {
    emit(CenterLoading());
    var data = await _centersRepo.getCenter(centerID);
    data.fold((failure) => emit(CenterError(errorMsg: failure.message)), (
      center,
    ) {
      emit(CenterSuccess(center: center));
    });
  }
}
