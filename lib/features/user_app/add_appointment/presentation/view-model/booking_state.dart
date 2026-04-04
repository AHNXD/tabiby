import '../../data/models/booking_request_model.dart';
import '../../data/models/centers_appointment_model.dart';
import '../../data/models/days_model.dart';
import '../../data/models/medical_attachment_item.dart';
import '../../data/models/times_model.dart';

const Object _unset = Object();

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingFailure extends BookingState {
  final String errMessage;
  final BookingSuccess? previousState;

  BookingFailure(this.errMessage, {this.previousState});
}

class BookingSuccess extends BookingState {
  final List<Centers> centers;
  final List<Days> days;
  final TimesModel? times;
  final BookingDepartmentType departmentType;
  final List<LabTestOption> availableLabTests;
  final List<MedicalImageTypeOption> availableMedicalImageTypes;
  final List<MedicalAttachmentItem> availableMedicalAttachments;

  final int? selectedCenterId;
  final String? selectedDate;
  final String? selectedTime;
  final String? selectedPeriodName;
  final int? selectedMedicalImageTypeId;
  final List<int> selectedLabTestIds;
  final List<MedicalAttachmentItem> selectedMedicalAttachments;
  final bool sendDiagnosisResult;

  final bool isLoadingDays;
  final bool isLoadingTimes;
  final bool isBooking;

  BookingSuccess({
    required this.centers,
    required this.departmentType,
    this.availableLabTests = const <LabTestOption>[],
    this.availableMedicalImageTypes = const <MedicalImageTypeOption>[],
    this.availableMedicalAttachments = const <MedicalAttachmentItem>[],
    this.days = const <Days>[],
    this.times,
    this.selectedCenterId,
    this.selectedDate,
    this.selectedTime,
    this.selectedPeriodName,
    this.selectedMedicalImageTypeId,
    this.selectedLabTestIds = const <int>[],
    this.selectedMedicalAttachments = const <MedicalAttachmentItem>[],
    this.sendDiagnosisResult = false,
    this.isLoadingDays = false,
    this.isLoadingTimes = false,
    this.isBooking = false,
  });

  BookingSuccess copyWith({
    List<Centers>? centers,
    List<Days>? days,
    BookingDepartmentType? departmentType,
    List<LabTestOption>? availableLabTests,
    List<MedicalImageTypeOption>? availableMedicalImageTypes,
    List<MedicalAttachmentItem>? availableMedicalAttachments,
    Object? times = _unset,
    Object? selectedCenterId = _unset,
    Object? selectedDate = _unset,
    Object? selectedTime = _unset,
    Object? selectedPeriodName = _unset,
    Object? selectedMedicalImageTypeId = _unset,
    List<int>? selectedLabTestIds,
    List<MedicalAttachmentItem>? selectedMedicalAttachments,
    bool? sendDiagnosisResult,
    bool? isLoadingDays,
    bool? isLoadingTimes,
    bool? isBooking,
  }) {
    return BookingSuccess(
      centers: centers ?? this.centers,
      departmentType: departmentType ?? this.departmentType,
      availableLabTests: availableLabTests ?? this.availableLabTests,
      availableMedicalImageTypes:
          availableMedicalImageTypes ?? this.availableMedicalImageTypes,
      availableMedicalAttachments:
          availableMedicalAttachments ?? this.availableMedicalAttachments,
      days: days ?? this.days,
      times: identical(times, _unset) ? this.times : times as TimesModel?,
      selectedCenterId: identical(selectedCenterId, _unset)
          ? this.selectedCenterId
          : selectedCenterId as int?,
      selectedDate: identical(selectedDate, _unset)
          ? this.selectedDate
          : selectedDate as String?,
      selectedTime: identical(selectedTime, _unset)
          ? this.selectedTime
          : selectedTime as String?,
      selectedPeriodName: identical(selectedPeriodName, _unset)
          ? this.selectedPeriodName
          : selectedPeriodName as String?,
      selectedMedicalImageTypeId: identical(selectedMedicalImageTypeId, _unset)
          ? this.selectedMedicalImageTypeId
          : selectedMedicalImageTypeId as int?,
      selectedLabTestIds: selectedLabTestIds ?? this.selectedLabTestIds,
      selectedMedicalAttachments:
          selectedMedicalAttachments ?? this.selectedMedicalAttachments,
      sendDiagnosisResult: sendDiagnosisResult ?? this.sendDiagnosisResult,
      isLoadingDays: isLoadingDays ?? this.isLoadingDays,
      isLoadingTimes: isLoadingTimes ?? this.isLoadingTimes,
      isBooking: isBooking ?? this.isBooking,
    );
  }
}

class AppointmentBookedSuccessfully extends BookingState {}
