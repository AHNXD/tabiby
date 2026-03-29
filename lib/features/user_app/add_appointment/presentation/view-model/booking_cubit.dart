import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

import 'booking_state.dart';

// booking_cubit.dart
class BookingCubit extends Cubit<BookingState> {
  final AddAppoinmentRepo _addAppoinmentRepo;
  final int doctorId;
  final BookingDepartmentType departmentType;
  final List<LabTestOption> availableLabTests;
  final MedicalFilesRepo _medicalFilesRepo;

  BookingCubit(
    this._addAppoinmentRepo,
    this._medicalFilesRepo,
    this.doctorId, {
    required this.departmentType,
    this.availableLabTests = LabTestOption.fallbackOptions,
  }) : super(BookingInitial());

  void toggleIncludeDiagnosis(bool value) {
    if (state is! BookingSuccess) return;
    emit((state as BookingSuccess).copyWith(includeDiagnosis: value));
  }

  void toggleIsEmergency(bool value) {
    if (state is! BookingSuccess) return;
    emit((state as BookingSuccess).copyWith(isEmergency: value));
  }

  void updateImageType(String? value) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(
        imageType: value == null || value.trim().isEmpty ? null : value,
      ),
    );
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

  void selectAttachedXray(MedicalAttachmentItem? attachment) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(selectedXrayAttachment: attachment),
    );
  }

  void selectAttachedLabResult(MedicalAttachmentItem? attachment) {
    if (state is! BookingSuccess) return;
    emit(
      (state as BookingSuccess).copyWith(
        selectedLabResultAttachment: attachment,
      ),
    );
  }

  Future<void> fetchCenters() async {
    emit(BookingLoading());
    var result = await _addAppoinmentRepo.getCenters(doctorId);
    final (
      List<MedicalAttachmentItem> xrayAttachments,
      List<MedicalAttachmentItem> labResultAttachments,
    ) = await _loadMedicalAttachments();

    result.fold(
      (failure) => emit(BookingFailure(failure.message)),
      (centers) => emit(
        BookingSuccess(
          centers: centers,
          departmentType: departmentType,
          availableLabTests: availableLabTests,
          availableXrayAttachments: xrayAttachments,
          availableLabResultAttachments: labResultAttachments,
        ),
      ),
    );
  }

  Future<void> selectCenter(int centerId) async {
    if (state is! BookingSuccess) return;
    final currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedCenterId: centerId,
        isLoadingDays: true,
        days: [],
        times: null,
        selectedDate: null,
        selectedTime: null,
      ),
    );

    var result = await _addAppoinmentRepo.getDays(doctorId, centerId);
    result.fold(
      (failure) => _emitFailure(
        failure.message,
        currentState.copyWith(
          isLoadingDays: false,
          selectedCenterId: centerId,
          days: const [],
          times: null,
          selectedDate: null,
          selectedTime: null,
          selectedPeriodName: null,
        ),
      ),
      (days) => emit(
        (state as BookingSuccess).copyWith(days: days, isLoadingDays: false),
      ),
    );
  }

  // 3. Select Day -> Fetch Times
  Future<void> selectDay(String date) async {
    if (state is! BookingSuccess) return;
    final currentState = state as BookingSuccess;

    emit(
      currentState.copyWith(
        selectedDate: date,
        isLoadingTimes: true,
        times: null,
        selectedTime: null,
      ),
    );

    var result = await _addAppoinmentRepo.getTimes(
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

    String? diagnosisName,
    String? diagnosisRatio,
    bool isEmergency = false,
  }) async {
    if (state is! BookingSuccess) return;
    final s = state as BookingSuccess;

    if (s.selectedCenterId == null ||
        s.selectedDate == null ||
        s.selectedTime == null) {
      return;
    }

    emit(s.copyWith(isBooking: true));
    final AppointmentBookingRequest request = AppointmentBookingRequest(
      doctorId: doctorId.toString(),
      centerId: s.selectedCenterId.toString(),
      date: s.selectedDate!,
      periodName: s.selectedPeriodName!,
      period: s.selectedTime!,
      note: note,
      isEmergency: isEmergency,
      diagnosisName: diagnosisName,
      diagnosisRatio: diagnosisRatio,
      imageType: s.departmentType.requiresImageType ? s.imageType : null,
      labTestsIds: s.departmentType.requiresLabTests
          ? s.selectedLabTestIds
          : const <int>[],
      attachedXrayId: s.departmentType.supportsMedicalAttachments
          ? s.selectedXrayAttachment?.id
          : null,
      attachedLabResultId: s.departmentType.supportsMedicalAttachments
          ? s.selectedLabResultAttachment?.id
          : null,
    );

    var result = await _addAppoinmentRepo.bookAppointment(request);

    result.fold(
      (failure) => _emitFailure(failure.message, s.copyWith(isBooking: false)),
      (success) => emit(AppointmentBookedSuccessfully()),
    );
  }

  void _emitFailure(String message, BookingSuccess fallbackState) {
    emit(BookingFailure(message, previousState: fallbackState));
    emit(fallbackState);
  }

  Future<(List<MedicalAttachmentItem>, List<MedicalAttachmentItem>)>
  _loadMedicalAttachments() async {
    final result = await _medicalFilesRepo.getMedicalFiles();

    return result.fold(
      (_) => (const <MedicalAttachmentItem>[], const <MedicalAttachmentItem>[]),
      (List<MedicalFile> files) {
        final List<MedicalAttachmentItem> attachments = files
            .map(MedicalAttachmentItem.fromMedicalFile)
            .toList();

        return (
          attachments
              .where((item) => item.type == MedicalAttachmentType.xray)
              .toList(),
          attachments
              .where((item) => item.type == MedicalAttachmentType.labResult)
              .toList(),
        );
      },
    );
  }
}
