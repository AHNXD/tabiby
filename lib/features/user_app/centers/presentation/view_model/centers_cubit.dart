import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../center_details/data/models/centers_model.dart';
import '../../data/repos/centers_repo.dart';


part 'centers_state.dart';

class CentersCubit extends Cubit<CentersState> {
  CentersCubit(this._centersRepo) : super(CentersInitial());

  final CentersRepo _centersRepo;

  Future getCenters() async {
    emit(CentersLoading());
    var data = await _centersRepo.getCenters();
    data.fold((failure) => emit(CentersError(errorMsg: failure.message)), (
      centers,
    ) {
      emit(CentersSuccess(centers: centers));

    });
  }
}