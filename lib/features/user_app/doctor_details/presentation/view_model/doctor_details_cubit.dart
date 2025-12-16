import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/doctors/data/repos/doctors_repo.dart';

import '../../../doctor_details/data/models/doctor_model.dart';

part 'doctor_details_state.dart';

class DoctorsDetailsCubit extends Cubit<DoctorsDetailsState> {
  DoctorsDetailsCubit(this._doctorsRepo) : super(DoctorsDetailsInitial());

  final DoctorsRepo _doctorsRepo;

  Future getDoctors(int? centerID, int? specialtyID) async {
    emit(DoctorsDetailsLoading());
    var data = await _doctorsRepo.getDoctors(centerID, specialtyID);
    data.fold((failure) => emit(DoctorsDetailsError(errorMsg: failure.message)), (
      doctors,
    ) {
      emit(DoctorsDetailsSuccess(doctors: doctors));
    });
  }
}
