import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/errors/failuer.dart';

import '../../../data/models/appointment_request_option.dart';
import '../../../data/models/doctor_appointment_details_model.dart';
import '../../../data/models/end_appointment_request.dart';
import '../../../data/models/end_appointment_result.dart';
import '../../../data/repos/doctor_appointment_details_repo.dart';
import 'end_appointment_state.dart';

class EndAppointmentCubit extends Cubit<EndAppointmentState> {
  final DoctorAppointmentDetailsRepo repo;

  EndAppointmentCubit(this.repo) : super(const EndAppointmentState());

  Future<void> loadFormData(DoctorAppointmentDetailsModel appointment) async {
    emit(
      state.copyWith(
        isLoadingOptions: true,
        hasPharmacy: appointment.hasPharmacy ?? false,
        availableLabTests: const [],
        availableMedicalImageTypes: const [],
        optionsErrorMessage: null,
        submitErrorMessage: null,
        result: null,
      ),
    );

    final List<String> errors = <String>[];

    final Either<Failure, List<AppointmentRequestOption>> rawLabResult =
        await repo.getLabTests(centerId: appointment.centerId);
    final Either<Failure, List<AppointmentRequestOption>> rawImageResult =
        await repo.getMedicalImageTypes(centerId: appointment.centerId);

    final List<AppointmentRequestOption> availableLabTests = rawLabResult.fold((
      Failure failure,
    ) {
      errors.add(failure.message);
      return const <AppointmentRequestOption>[];
    }, (List<AppointmentRequestOption> tests) => tests);

    final List<AppointmentRequestOption> availableMedicalImageTypes =
        rawImageResult.fold((Failure failure) {
          errors.add(failure.message);
          return const <AppointmentRequestOption>[];
        }, (List<AppointmentRequestOption> types) => types);

    emit(
      state.copyWith(
        isLoadingOptions: false,
        hasPharmacy: appointment.hasPharmacy ?? false,
        availableLabTests: availableLabTests,
        availableMedicalImageTypes: availableMedicalImageTypes,
        optionsErrorMessage: errors.isEmpty ? null : errors.first,
        submitErrorMessage: null,
        result: null,
      ),
    );
  }

  Future<void> endAppointment(EndAppointmentRequest request) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        submitErrorMessage: null,
        result: null,
      ),
    );

    final Either<Failure, EndAppointmentResult> result = await repo
        .endAppointment(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitErrorMessage: failure.message,
            result: null,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitErrorMessage: null,
            result: data,
          ),
        );
      },
    );
  }

  void clearSubmissionState() {
    emit(state.copyWith(submitErrorMessage: null, result: null));
  }

  Future<void> retryLoadingOptions(
    DoctorAppointmentDetailsModel appointment,
  ) async {
    await loadFormData(appointment);
  }
}
