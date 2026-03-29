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
  final List<MedicalAttachmentItem> availableXrayAttachments;
  final List<MedicalAttachmentItem> availableLabResultAttachments;

  final int? selectedCenterId;
  final String? selectedDate;
  final String? selectedTime;

  final String? selectedPeriodName;
  final String? imageType;
  final List<int> selectedLabTestIds;
  final MedicalAttachmentItem? selectedXrayAttachment;
  final MedicalAttachmentItem? selectedLabResultAttachment;

  // Flags to show loading for specific sectsions
  final bool isLoadingDays;
  final bool isLoadingTimes;
  final bool isBooking;

  final bool includeDiagnosis; // Checkbox state
  final bool isEmergency;

  BookingSuccess({
    required this.centers,
    required this.departmentType,
    required this.availableLabTests,
    this.availableXrayAttachments = const [],
    this.availableLabResultAttachments = const [],
    this.days = const [],
    this.times,
    this.selectedCenterId,
    this.selectedDate,
    this.selectedTime,
    this.selectedPeriodName,
    this.imageType,
    this.selectedLabTestIds = const <int>[],
    this.selectedXrayAttachment,
    this.selectedLabResultAttachment,
    this.isLoadingDays = false,
    this.isLoadingTimes = false,
    this.isBooking = false,
    this.includeDiagnosis = false,
    this.isEmergency = false,
  });

  BookingSuccess copyWith({
    List<Centers>? centers,
    List<Days>? days,
    BookingDepartmentType? departmentType,
    List<LabTestOption>? availableLabTests,
    List<MedicalAttachmentItem>? availableXrayAttachments,
    List<MedicalAttachmentItem>? availableLabResultAttachments,
    Object? times = _unset,
    Object? selectedCenterId = _unset,
    Object? selectedDate = _unset,
    Object? selectedTime = _unset,
    Object? selectedPeriodName = _unset,
    Object? imageType = _unset,
    List<int>? selectedLabTestIds,
    Object? selectedXrayAttachment = _unset,
    Object? selectedLabResultAttachment = _unset,
    bool? isLoadingDays,
    bool? isLoadingTimes,
    bool? isBooking,
    bool? includeDiagnosis,
    bool? isEmergency,
  }) {
    return BookingSuccess(
      centers: centers ?? this.centers,
      departmentType: departmentType ?? this.departmentType,
      availableLabTests: availableLabTests ?? this.availableLabTests,
      availableXrayAttachments:
          availableXrayAttachments ?? this.availableXrayAttachments,
      availableLabResultAttachments:
          availableLabResultAttachments ?? this.availableLabResultAttachments,
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
      imageType: identical(imageType, _unset)
          ? this.imageType
          : imageType as String?,
      selectedLabTestIds: selectedLabTestIds ?? this.selectedLabTestIds,
      selectedXrayAttachment: identical(selectedXrayAttachment, _unset)
          ? this.selectedXrayAttachment
          : selectedXrayAttachment as MedicalAttachmentItem?,
      selectedLabResultAttachment:
          identical(selectedLabResultAttachment, _unset)
          ? this.selectedLabResultAttachment
          : selectedLabResultAttachment as MedicalAttachmentItem?,
      isLoadingDays: isLoadingDays ?? this.isLoadingDays,
      isLoadingTimes: isLoadingTimes ?? this.isLoadingTimes,
      isBooking: isBooking ?? this.isBooking,
      includeDiagnosis: includeDiagnosis ?? this.includeDiagnosis,
      isEmergency: isEmergency ?? this.isEmergency,
    );
  }
}

class AppointmentBookedSuccessfully extends BookingState {}
