enum BookingDepartmentType { doctor, radiology, laboratory }

extension BookingDepartmentTypeX on BookingDepartmentType {
  bool get requiresImageType => this == BookingDepartmentType.radiology;

  bool get requiresLabTests => this == BookingDepartmentType.laboratory;

  bool get supportsMedicalAttachments => this == BookingDepartmentType.doctor;

  static BookingDepartmentType fromSpecialtyName(String? specialtyName) {
    final String normalized = specialtyName?.trim().toLowerCase() ?? '';

    if (normalized.contains('radiology') ||
        normalized.contains('imaging') ||
        normalized.contains('x-ray') ||
        normalized.contains('xray') ||
        normalized.contains('اشعة') ||
        normalized.contains('أشعة')) {
      return BookingDepartmentType.radiology;
    }

    if (normalized.contains('laboratory') ||
        normalized.contains('lab') ||
        normalized.contains('مختبر') ||
        normalized.contains('تحاليل')) {
      return BookingDepartmentType.laboratory;
    }

    return BookingDepartmentType.doctor;
  }
}

class LabTestOption {
  final int id;
  final String name;

  const LabTestOption({required this.id, required this.name});

  factory LabTestOption.fromJson(Map<String, dynamic> json) {
    return LabTestOption(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  static const List<LabTestOption> fallbackOptions = <LabTestOption>[
    LabTestOption(id: 1, name: 'Complete Blood Count'),
    LabTestOption(id: 2, name: 'Blood Glucose'),
    LabTestOption(id: 3, name: 'Liver Function Test'),
    LabTestOption(id: 4, name: 'Kidney Function Test'),
    LabTestOption(id: 5, name: 'Thyroid Panel'),
    LabTestOption(id: 6, name: 'Lipid Profile'),
  ];
}

class AppointmentBookingRequest {
  final String doctorId;
  final String centerId;
  final String date;
  final String periodName;
  final String period;
  final String note;
  final bool isEmergency;
  final String? diagnosisName;
  final String? diagnosisRatio;
  final String? imageType;
  final List<int> labTestsIds;
  final int? attachedXrayId;
  final int? attachedLabResultId;

  const AppointmentBookingRequest({
    required this.doctorId,
    required this.centerId,
    required this.date,
    required this.periodName,
    required this.period,
    required this.note,
    required this.isEmergency,
    this.diagnosisName,
    this.diagnosisRatio,
    this.imageType,
    this.labTestsIds = const <int>[],
    this.attachedXrayId,
    this.attachedLabResultId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'time': period,
      'note': note,
      'is_emergency': isEmergency ? 1 : 0,
      'diagnosis_name': diagnosisName,
      'diagnosis_ratio': diagnosisRatio,
    };

    if (imageType != null && imageType!.trim().isNotEmpty) {
      data['image_type'] = imageType;
    }

    if (labTestsIds.isNotEmpty) {
      data['lab_tests_ids'] = labTestsIds;
    }

    if (attachedXrayId != null) {
      data['attached_xray_id'] = attachedXrayId;
    }

    if (attachedLabResultId != null) {
      data['attached_lab_result_id'] = attachedLabResultId;
    }

    return data;
  }
}
