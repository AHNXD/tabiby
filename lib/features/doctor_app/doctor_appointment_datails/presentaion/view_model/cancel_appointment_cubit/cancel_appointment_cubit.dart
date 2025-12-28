import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tabiby/core/errors/failuer.dart';

import '../../../data/repos/doctor_appointment_details_repo.dart';
import 'cancel_appointment_state.dart';


class CancelAppointmentCubit extends Cubit<CancelAppointmentState> {
  final DoctorAppointmentDetailsRepo repo;

  CancelAppointmentCubit(this.repo)
      : super(CancelAppointmentInitial());

  Future<void> cancelAppointment(int appointmentId) async {
    emit(CancelAppointmentLoading());

    final Either<Failure, String> result =
        await repo.cancelAppointment(appointmentId);

    result.fold(
      (failure) {
        emit(CancelAppointmentFailure(failure.message));
      },
      (message) {
        emit(CancelAppointmentSuccess(message));
      },
    );
  }
}
