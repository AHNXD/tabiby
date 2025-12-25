import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/doctor_appointments_model.dart';
import '../../data/repos/doctor_appointment_repo.dart';


part 'doctor_appointments_state.dart';

class DoctorsAppointmentsCubit extends Cubit<DoctorsAppointmentsState> {
  DoctorsAppointmentsCubit(this._doctorsAppointmentRepo) : super(DoctorsAppointmentInitial());

  final DoctorAppointmentsRepo _doctorsAppointmentRepo;

  Future<void> getDoctorAppointments(int? center, String? date) async {
    emit(DoctorsAppointmentLoading());
    
    final result = await _doctorsAppointmentRepo.getDoctorAppointments(center, date);
    
    result.fold(
      (failure) => emit(DoctorsAppointmentError(errorMsg: failure.message)),
      (doctorsAppointment) => emit(DoctorsAppointmentSuccess(doctorsAppointment: doctorsAppointment)),
    );
  }
}
