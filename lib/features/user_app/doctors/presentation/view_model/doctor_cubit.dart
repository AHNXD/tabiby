import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/doctors/data/repos/doctors_repo.dart';

import '../../../doctor_details/data/models/doctor_model.dart';


part 'doctor_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this._doctorsRepo) : super(DoctorsInitial());

  final DoctorsRepo _doctorsRepo;

  Future getDoctors() async {
    emit(DoctorsLoading());
    var data = await _doctorsRepo.getDoctors();
    data.fold((failure) => emit(DoctorsError(errorMsg: failure.message)), (
      doctors,
    ) {
      emit(DoctorsSuccess(doctors: doctors));
    });
  }
}
