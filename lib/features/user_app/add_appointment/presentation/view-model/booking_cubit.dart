import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/days_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AddAppoinmentRepo _addAppoinmentRepo;
  final int doctorId;
  final BookingDepartmentType departmentType;
  final MedicalFilesRepo _medicalFilesRepo;

  BookingCubit(
    this._addAppoinmentRepo,
    this._medicalFilesRepo,
    this.doctorId, {
    required this.departmentType,
  }) : super(BookingInitial());

  void updateMedicalImageType(int? value) {
    if (state is! BookingSuccess) return;
    emit((state as BookingSuccess).copyWith(selectedMedicalImageTypeId: value));
  }

  void toggleLabTestSelection(int labTestId) {
    if (state is! BookingSuccess) return;
    final BookingSuccess currentState = state as BookingSuccess;
    final List<int> selectedIds = List<int>.from(
      currentState.selectedLabTestIds,
    );

    if (selectedIds.contains(labTestId)) {
      selectedIds.remove(labTestId);
    } else {
      selectedIds.add(labTestId);
    }

    emit(currentState.copyWith(selectedLabTestIds: selectedIds));
  }

  void updateSelectedMedicalAttachments(
    List<MedicalAttachmentItem> attachments,
  ) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(
        selectedMedicalAttachments: attachments,
      ),
    );
  }

  void updateSendDiagnosisResult(bool value) {
    if (state is! BookingSuccess) return;
    emit((state as BookingSuccess).copyWith(sendDiagnosisResult: value));
  }

  Future<void> fetchCenters() async {
    emit(BookingLoading());

    final centersResult = await _addAppoinmentRepo.getCenters(doctorId);

    await centersResult.fold(
      (failure) async => emit(BookingFailure(failure.message)),
      (centers) async {
        final List<MedicalAttachmentItem> attachments =
            departmentType.supportsMedicalAttachments
            ? await _loadMedicalAttachments()
            : const <MedicalAttachmentItem>[];

        emit(
          BookingSuccess(
            centers: centers,
            departmentType: departmentType,
            availableMedicalAttachments: attachments,
          ),
        );
      },
    );
  }

  Future<void> selectCenter(int centerId) async {
    if (state is! BookingSuccess) return;
    final BookingSuccess currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedCenterId: centerId,
        isLoadingDays: true,
        days: <Days>[],
        times: null,
        selectedDate: null,
        selectedTime: null,
        selectedPeriodName: null,
        selectedMedicalImageTypeId: null,
        selectedLabTestIds: const <int>[],
        availableLabTests: const <LabTestOption>[],
        availableMedicalImageTypes: const <MedicalImageTypeOption>[],
      ),
    );

    final result = await _addAppoinmentRepo.getDays(doctorId, centerId);
    await result.fold(
      (failure) async => _emitFailure(
        failure.message,
        currentState.copyWith(
          isLoadingDays: false,
          selectedCenterId: centerId,
          days: const <Days>[],
          times: null,
          selectedDate: null,
          selectedTime: null,
          selectedPeriodName: null,
          selectedMedicalImageTypeId: null,
          selectedLabTestIds: const <int>[],
          availableLabTests: const <LabTestOption>[],
          availableMedicalImageTypes: const <MedicalImageTypeOption>[],
        ),
      ),
      (days) async {
        final BookingSuccess baseState = (state as BookingSuccess).copyWith(
          days: days,
          isLoadingDays: false,
        );

        final List<LabTestOption>? labTests = await _loadLabTestsForCenter(
          centerId,
          baseState,
        );
        if (labTests == null) {
          return;
        }

        final List<MedicalImageTypeOption>? medicalImageTypes =
            await _loadMedicalImageTypesForCenter(centerId, baseState);
        if (medicalImageTypes == null) {
          return;
        }

        emit(
          baseState.copyWith(
            availableLabTests: labTests,
            availableMedicalImageTypes: medicalImageTypes,
          ),
        );
      },
    );
  }

  Future<void> selectDay(String date) async {
    if (state is! BookingSuccess) return;
    final BookingSuccess currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedDate: date,
        isLoadingTimes: true,
        times: null,
        selectedTime: null,
        selectedPeriodName: null,
      ),
    );

    final result = await _addAppoinmentRepo.getTimes(
      doctorId,
      currentState.selectedCenterId,
      date,
    );
    result.fold(
      (failure) => _emitFailure(
        failure.message,
        currentState.copyWith(
          selectedDate: date,
          isLoadingTimes: false,
          times: null,
          selectedTime: null,
          selectedPeriodName: null,
        ),
      ),
      (times) => emit(
        (state as BookingSuccess).copyWith(times: times, isLoadingTimes: false),
      ),
    );
  }

  void selectTime(String time, String periodName) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(
        selectedTime: time,
        selectedPeriodName: periodName,
      ),
    );
  }

  Future<void> bookAppointment(
    String note, {
    Map<String, dynamic>? diagnosis,
    double? diagnosisRatio,
    String? diagnosisName,
    bool? isEmergency,
  }) async {
    if (state is! BookingSuccess) return;
    final BookingSuccess s = state as BookingSuccess;

    if (s.selectedCenterId == null ||
        s.selectedDate == null ||
        s.selectedTime == null ||
        s.selectedPeriodName == null) {
      return;
    }

    emit(s.copyWith(isBooking: true));
    final AppointmentBookingRequest request = AppointmentBookingRequest(
      doctorId: doctorId.toString(),
      centerId: s.selectedCenterId.toString(),
      date: s.selectedDate!,
      periodName: s.selectedPeriodName!,
      time: s.selectedTime!,
      type: s.departmentType,
      note: note,
      attachedMedicalRecords: s.departmentType.supportsMedicalAttachments
          ? s.selectedMedicalAttachments
                .map(
                  (MedicalAttachmentItem item) =>
                      AppointmentMedicalRecordAttachment(
                        recordSource: item.recordSource,
                        recordId: item.id,
                      ),
                )
                .toList()
          : const <AppointmentMedicalRecordAttachment>[],
      labTests: s.departmentType.requiresLabTests
          ? s.selectedLabTestIds
          : const <int>[],
      typeOfMedicalImageId: s.departmentType.requiresImageType
          ? s.selectedMedicalImageTypeId
          : null,
      diagnosis: s.sendDiagnosisResult ? diagnosis : null,
      diagnosisRatio: s.sendDiagnosisResult ? diagnosisRatio : null,
      diagnosisName: s.sendDiagnosisResult ? diagnosisName : null,
      isEmergency: s.sendDiagnosisResult ? isEmergency : null,
    );

    final result = await _addAppoinmentRepo.bookAppointment(request);

    result.fold(
      (failure) => _emitFailure(failure.message, s.copyWith(isBooking: false)),
      (_) => emit(AppointmentBookedSuccessfully()),
    );
  }

  void _emitFailure(String message, BookingSuccess fallbackState) {
    emit(BookingFailure(message, previousState: fallbackState));
    emit(fallbackState);
  }

  Future<List<MedicalAttachmentItem>> _loadMedicalAttachments() async {
    final result = await _medicalFilesRepo.getMedicalFiles();

    return result.fold(
      (_) => const <MedicalAttachmentItem>[],
      (List<MedicalFile> files) =>
          files.map(MedicalAttachmentItem.fromMedicalFile).toList(),
    );
  }

  Future<List<LabTestOption>?> _loadLabTestsForCenter(
    int centerId,
    BookingSuccess fallbackState,
  ) async {
    if (!departmentType.requiresLabTests) {
      return const <LabTestOption>[];
    }

    final result = await _addAppoinmentRepo.getLabTests(centerId);
    return result.fold((failure) {
      _emitFailure(
        failure.message,
        fallbackState.copyWith(
          availableLabTests: const <LabTestOption>[],
          selectedLabTestIds: const <int>[],
        ),
      );
      return null;
    }, (tests) => tests);
  }

  Future<List<MedicalImageTypeOption>?> _loadMedicalImageTypesForCenter(
    int centerId,
    BookingSuccess fallbackState,
  ) async {
    if (!departmentType.requiresImageType) {
      return const <MedicalImageTypeOption>[];
    }

    final result = await _addAppoinmentRepo.getMedicalImageTypes(centerId);
    return result.fold((failure) {
      _emitFailure(
        failure.message,
        fallbackState.copyWith(
          availableMedicalImageTypes: const <MedicalImageTypeOption>[],
          selectedMedicalImageTypeId: null,
        ),
      );
      return null;
    }, (types) => types);
  }
}
