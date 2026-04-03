import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/appointment_details_model.dart';
import '../../../data/repos/my_appointments/my_appointments_repo.dart';

part 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsCubit(this._repo) : super(AppointmentDetailsInitial());

  final MyAppointmentsRepo _repo;

  Future<void> getAppointmentDetails(int appointmentId) async {
    emit(AppointmentDetailsLoading());

    final result = await _repo.getAppointmentDetails(appointmentId);
    result.fold(
      (failure) => emit(AppointmentDetailsError(errorMsg: failure.message)),
      (details) => emit(AppointmentDetailsSuccess(details: details)),
    );
  }
}
