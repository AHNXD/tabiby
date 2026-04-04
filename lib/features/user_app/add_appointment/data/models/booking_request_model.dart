enum BookingDepartmentType { doctor, radiology, laboratory }

extension BookingDepartmentTypeX on BookingDepartmentType {
  bool get requiresImageType => this == BookingDepartmentType.radiology;

  bool get requiresLabTests => this == BookingDepartmentType.laboratory;

  bool get supportsMedicalAttachments => this == BookingDepartmentType.doctor;

  String get apiValue {
    switch (this) {
      case BookingDepartmentType.doctor:
        return 'doctor';
      case BookingDepartmentType.radiology:
        return 'radiology';
      case BookingDepartmentType.laboratory:
        return 'lab';
    }
  }

  static BookingDepartmentType fromDoctorType(String? doctorType) {
    switch (doctorType?.trim().toLowerCase()) {
      case 'radiology':
        return BookingDepartmentType.radiology;
      case 'lab':
      case 'laboratory':
        return BookingDepartmentType.laboratory;
      case 'doctor':
      default:
        return BookingDepartmentType.doctor;
    }
  }

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
  final double? price;
  final double? selectedCenterPrice;
  final int? centerId;

  const LabTestOption({
    required this.id,
    required this.name,
    this.price,
    this.selectedCenterPrice,
    this.centerId,
  });

  factory LabTestOption.fromJson(Map<String, dynamic> json) {
    return LabTestOption(
      id: _asInt(json['id']),
      name: json['name']?.toString().trim() ?? '',
      price: _asNullableDouble(json['price']),
      selectedCenterPrice: _asNullableDouble(json['selected_center_price']),
      centerId: _asNullableInt(json['center_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'selected_center_price': selectedCenterPrice,
      'center_id': centerId,
    };
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

class MedicalImageTypeOption {
  final int id;
  final String name;
  final double? price;
  final double? selectedCenterPrice;
  final int? centerId;

  const MedicalImageTypeOption({
    required this.id,
    required this.name,
    this.price,
    this.selectedCenterPrice,
    this.centerId,
  });

  factory MedicalImageTypeOption.fromJson(Map<String, dynamic> json) {
    return MedicalImageTypeOption(
      id: _asInt(json['id']),
      name: json['name']?.toString().trim() ?? '',
      price: _asNullableDouble(json['price']),
      selectedCenterPrice: _asNullableDouble(json['selected_center_price']),
      centerId: _asNullableInt(json['center_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'selected_center_price': selectedCenterPrice,
      'center_id': centerId,
    };
  }
}

class AppointmentMedicalRecordAttachment {
  final String recordSource;
  final int recordId;

  const AppointmentMedicalRecordAttachment({
    required this.recordSource,
    required this.recordId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'record_source': recordSource,
      'record_id': recordId,
    };
  }
}

class AppointmentBookingRequest {
  final String doctorId;
  final String centerId;
  final String date;
  final String periodName;
  final String time;
  final BookingDepartmentType type;
  final String? note;
  final List<AppointmentMedicalRecordAttachment> attachedMedicalRecords;
  final List<int> labTests;
  final int? typeOfMedicalImageId;
  final Map<String, dynamic>? diagnosis;
  final double? diagnosisRatio;
  final String? diagnosisName;
  final bool? isEmergency;

  const AppointmentBookingRequest({
    required this.doctorId,
    required this.centerId,
    required this.date,
    required this.periodName,
    required this.time,
    required this.type,
    this.note,
    this.attachedMedicalRecords = const <AppointmentMedicalRecordAttachment>[],
    this.labTests = const <int>[],
    this.typeOfMedicalImageId,
    this.diagnosis,
    this.diagnosisRatio,
    this.diagnosisName,
    this.isEmergency,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'type': type.apiValue,
      'time': time,
    };

    if (note != null && note!.trim().isNotEmpty) {
      data['note'] = note!.trim();
    }

    if (type.supportsMedicalAttachments && attachedMedicalRecords.isNotEmpty) {
      data['attached_medical_records'] = attachedMedicalRecords
          .map((AppointmentMedicalRecordAttachment item) => item.toJson())
          .toList();
    }

    if (type.requiresLabTests) {
      data['lab_tests'] = labTests;
    }

    if (type.requiresImageType && typeOfMedicalImageId != null) {
      data['type_of_medical_image_id'] = typeOfMedicalImageId;
    }

    if (diagnosis != null && diagnosis!.isNotEmpty) {
      data['diagnosis'] = diagnosis;
    }

    if (diagnosisRatio != null) {
      data['diagnosis_ratio'] = diagnosisRatio;
    }

    if (diagnosisName != null && diagnosisName!.trim().isNotEmpty) {
      data['diagnosis_name'] = diagnosisName!.trim();
    }

    if (isEmergency != null) {
      data['is_emergency'] = isEmergency;
    }

    return data;
  }
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

double? _asNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}
