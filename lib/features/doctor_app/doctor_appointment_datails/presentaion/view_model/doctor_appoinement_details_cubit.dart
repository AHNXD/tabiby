import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/doctor_appointment_details_model.dart';
import '../../data/repos/doctor_appointment_details_repo.dart';


part 'doctor_appointment_details_state.dart';

class DoctorsAppointmentDetailsCubit extends Cubit<DoctorsAppointmentDetailsState> {
  DoctorsAppointmentDetailsCubit(this._doctorsAppointmentDetailsRepo) : super(DoctorsAppointmentDetailsInitial());

  final DoctorAppointmentDetailsRepo _doctorsAppointmentDetailsRepo;

  Future<void> getDoctorAppointmentDetails(int id) async {
    emit(DoctorsAppointmentDetailsLoading());
    
    final result = await _doctorsAppointmentDetailsRepo.getDoctorAppointmentDetails(id);
    
    result.fold(
      (failure) => emit(DoctorsAppointmentDetailsError(errorMsg: failure.message)),
      (doctorsAppointmentDetails) => emit(DoctorAppointmentDetailsSuccess(doctorsAppointmentDetails: doctorsAppointmentDetails)),
    );
  }
}
