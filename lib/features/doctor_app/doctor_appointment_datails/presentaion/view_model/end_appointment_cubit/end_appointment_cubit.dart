import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/core/models/prescription_item.dart';

import '../../../data/models/end_appointment_request.dart';
import '../../../data/repos/doctor_appointment_details_repo.dart';
import 'end_appointment_state.dart';

class EndAppointmentCubit extends Cubit<EndAppointmentState> {
  final DoctorAppointmentDetailsRepo repo;

  EndAppointmentCubit(this.repo) : super(EndAppointmentInitial());

  Future<void> endAppointment(
    int appointmentId,
    String note,
    List<PrescriptionItem> prescriptionList,
  ) async {
    emit(EndAppointmentLoading());

    final Either<Failure, String> result = await repo.endAppointment(
      EndAppointmentRequest(
        appointmentId: appointmentId,
        note: note,
        prescriptionList: prescriptionList,
      ),
    );

    result.fold(
      (failure) {
        emit(EndAppointmentFailure(failure.message));
      },
      (message) {
        emit(EndAppointmentSuccess(message));
      },
    );
  }
}
