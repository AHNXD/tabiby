import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/doctors/data/repos/doctors_repo.dart';

import '../../../doctor_details/data/models/doctor_model.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit(this._doctorsRepo) : super(DoctorDetailsInitial());

  final DoctorsRepo _doctorsRepo;

  Future getDoctor(int? centerID) async {
    emit(DoctorDetailsLoading());
    var data = await _doctorsRepo.getDoctor(centerID);
    data.fold((failure) => emit(DoctorDetailsError(errorMsg: failure.message)), (
      doctor,
    ) {
      emit(DoctorDetailsSuccess(doctor: doctor));
    });
  }
}
  