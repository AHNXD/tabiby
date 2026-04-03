import 'package:tabiby/core/models/medical_record_attachment.dart';

class DoctorAppointmentDetailsModel {
  int? id;
  String? type;
  String? status;
  Patient? patient;
  DoctorSummary? doctor;
  String? note;
  String? doctorNote;
  Diagnose? diagnose;
  String? date;
  String? time;
  double? price;
  bool? hasPharmacy;
  bool? sendToPharmacy;
  int? centerId;
  MedicalRecordAttachment? attachedXray;
  MedicalRecordAttachment? attachedLabResult;
  List<MedicalRecordAttachment> attachedMedicalRecords =
      const <MedicalRecordAttachment>[];
  List<PrescriptionItemDetails> prescriptionItems =
      const <PrescriptionItemDetails>[];
  List<LabRequestDetails> labRequests = const <LabRequestDetails>[];
  List<RadiologyRequestDetails> radiologyRequests =
      const <RadiologyRequestDetails>[];

  DoctorAppointmentDetailsModel({
    this.id,
    this.type,
    this.status,
    this.patient,
    this.doctor,
    this.note,
    this.doctorNote,
    this.diagnose,
    this.date,
    this.time,
    this.price,
    this.hasPharmacy,
    this.sendToPharmacy,
    this.centerId,
    this.attachedXray,
    this.attachedLabResult,
    this.attachedMedicalRecords = const <MedicalRecordAttachment>[],
    this.prescriptionItems = const <PrescriptionItemDetails>[],
    this.labRequests = const <LabRequestDetails>[],
    this.radiologyRequests = const <RadiologyRequestDetails>[],
  });

  DoctorAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    type = json['type']?.toString();
    status = json['status']?.toString();
    patient = json['patient'] != null
        ? Patient.fromJson(json['patient'])
        : null;
    doctor = json['doctor'] is Map<String, dynamic>
        ? DoctorSummary.fromJson(json['doctor'] as Map<String, dynamic>)
        : null;
    note = json['patient_note']?.toString() ?? json['note']?.toString();
    doctorNote = json['doctor_note']?.toString();
    diagnose = json['diagnosis'] != null
        ? Diagnose.fromJson(json['diagnosis'])
        : null;
    date = json['date']?.toString();
    time = json['time']?.toString();
    price = _toDouble(json['price']);
    hasPharmacy = _toBool(json['has_pharmacy']);
    sendToPharmacy = _toBool(json['send_to_pharmacy']);
    centerId = _toInt(
      json['center_id'] ?? json['doctor_center_id'] ?? json['center']?['id'],
    );
    attachedXray = _parseAttachment(
      mapValue:
          json['radiology_result'] ?? json['attached_xray'] ?? json['xray'],
      urlValue: json['radiology_result_url'] ?? json['xray_url'],
      fallbackTitle: 'Radiology Result',
      fallbackType: 'radiology_result',
    );
    attachedLabResult = _parseAttachment(
      mapValue:
          json['lab_result'] ?? json['attached_lab_result'] ?? json['lab'],
      urlValue: json['lab_result_url'] ?? json['lab_url'],
      fallbackTitle: 'Lab Result',
      fallbackType: 'lab_result',
    );
    attachedMedicalRecords = _parseAttachmentList(
      json['attached_medical_records'],
    );
    prescriptionItems = _parseList(
      json['prescription_items'],
      PrescriptionItemDetails.fromJson,
    );
    labRequests = _parseList(json['lab_requests'], LabRequestDetails.fromJson);
    radiologyRequests = _parseList(
      json['radiology_requests'],
      RadiologyRequestDetails.fromJson,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    data['patient_note'] = note;
    data['doctor_note'] = doctorNote;
    if (diagnose != null) {
      data['diagnosis'] = diagnose!.toJson();
    }
    data['date'] = date;
    data['time'] = time;
    data['price'] = price;
    data['has_pharmacy'] = hasPharmacy;
    data['send_to_pharmacy'] = sendToPharmacy;
    data['center_id'] = centerId;
    if (attachedXray != null) {
      data['radiology_result'] = attachedXray!.toJson();
    }
    if (attachedLabResult != null) {
      data['lab_result'] = attachedLabResult!.toJson();
    }
    data['attached_medical_records'] = attachedMedicalRecords
        .map((MedicalRecordAttachment attachment) => attachment.toJson())
        .toList();
    data['prescription_items'] = prescriptionItems
        .map((PrescriptionItemDetails item) => item.toJson())
        .toList();
    data['lab_requests'] = labRequests
        .map((LabRequestDetails item) => item.toJson())
        .toList();
    data['radiology_requests'] = radiologyRequests
        .map((RadiologyRequestDetails item) => item.toJson())
        .toList();
    return data;
  }

  List<MedicalRecordAttachment> get visibleMedicalRecords {
    if (attachedMedicalRecords.isNotEmpty) {
      return attachedMedicalRecords;
    }

    return <MedicalRecordAttachment>[
      if (attachedXray != null) attachedXray!,
      if (attachedLabResult != null) attachedLabResult!,
    ];
  }

  MedicalRecordAttachment? _parseAttachment({
    required dynamic mapValue,
    required dynamic urlValue,
    required String fallbackTitle,
    required String fallbackType,
  }) {
    if (mapValue is Map<String, dynamic>) {
      return MedicalRecordAttachment.fromJson(
        mapValue,
        fallbackTitle: fallbackTitle,
        fallbackType: fallbackType,
      );
    }

    final String? url = urlValue?.toString();
    if (url == null || url.isEmpty) {
      return null;
    }

    return MedicalRecordAttachment.fromUrl(
      url,
      fallbackTitle: fallbackTitle,
      fallbackType: fallbackType,
    );
  }

  List<MedicalRecordAttachment> _parseAttachmentList(dynamic value) {
    if (value is! List<dynamic>) {
      return const <MedicalRecordAttachment>[];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(MedicalRecordAttachment.fromJson)
        .where((MedicalRecordAttachment attachment) {
          final String? url = attachment.url;
          return url != null && url.isNotEmpty;
        })
        .toList();
  }

  List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (value is! List<dynamic>) {
      return <T>[];
    }

    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('${value ?? ''}');
  }

  static double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse('${value ?? ''}');
  }

  static bool? _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String normalized = value?.toString().trim().toLowerCase() ?? '';
    if (normalized == '1' || normalized == 'true') {
      return true;
    }
    if (normalized == '0' || normalized == 'false') {
      return false;
    }

    return null;
  }
}

class PrescriptionItemDetails {
  final String medicineName;
  final String dose;
  final String frequency;
  final String startDate;
  final String endDate;
  final String instructions;

  const PrescriptionItemDetails({
    required this.medicineName,
    required this.dose,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.instructions,
  });

  factory PrescriptionItemDetails.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemDetails(
      medicineName: json['medicine_name']?.toString() ?? '',
      dose: json['dose']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'medicine_name': medicineName,
      'dose': dose,
      'frequency': frequency,
      'start_date': startDate,
      'end_date': endDate,
      'instructions': instructions,
    };
  }
}

class LabRequestDetails {
  final String name;
  final String notes;

  const LabRequestDetails({required this.name, required this.notes});

  factory LabRequestDetails.fromJson(Map<String, dynamic> json) {
    return LabRequestDetails(
      name: json['name']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'notes': notes};
  }
}

class RadiologyRequestDetails {
  final String typeName;
  final String notes;

  const RadiologyRequestDetails({required this.typeName, required this.notes});

  factory RadiologyRequestDetails.fromJson(Map<String, dynamic> json) {
    return RadiologyRequestDetails(
      typeName: json['type_name']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type_name': typeName, 'notes': notes};
  }
}

class Patient {
  String? img;
  String? fullName;
  String? gender;
  int? height;
  int? weight;
  bool? hasChildren;
  int? numberOfChildren;
  String? birthDate;
  int? smoker;
  String? maritalStatus;

  Patient({
    this.img,
    this.fullName,
    this.gender,
    this.height,
    this.weight,
    this.hasChildren,
    this.numberOfChildren,
    this.birthDate,
    this.smoker,
    this.maritalStatus,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    img = json['image'];
    fullName = json['full_name'];
    gender = json['gender'];
    height = _toInt(json['height']);
    weight = _toInt(json['weight']);
    hasChildren = json['has_children'];
    numberOfChildren = _toInt(json['number_of_children']);
    birthDate = json['birth_date']?.toString();
    smoker = _toInt(json['smoker']);
    maritalStatus = json['marital_status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = img;
    data['full_name'] = fullName;
    data['gender'] = gender;
    data['height'] = height;
    data['weight'] = weight;
    data['has_children'] = hasChildren;
    data['number_of_children'] = numberOfChildren;
    data['birth_date'] = birthDate;
    data['smoker'] = smoker;
    data['marital_status'] = maritalStatus;
    return data;
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('${value ?? ''}');
  }
}

class DoctorSummary {
  int? id;
  String? fullName;
  String? image;
  String? specialization;

  DoctorSummary({this.id, this.fullName, this.image, this.specialization});

  DoctorSummary.fromJson(Map<String, dynamic> json) {
    id = DoctorAppointmentDetailsModel._toInt(json['id']);
    fullName = json['full_name']?.toString();
    image = json['image']?.toString();
    specialization = json['specialization']?.toString();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'full_name': fullName,
      'image': image,
      'specialization': specialization,
    };
  }
}

class Diagnose {
  String? name;
  int? ratio;
  bool? isEmergency;

  Diagnose({this.name, this.ratio, this.isEmergency});

  Diagnose.fromJson(Map<String, dynamic> json) {
    name = json['diagnosis_name']?.toString();
    ratio = json['diagnosis_ratio'] is int
        ? json['diagnosis_ratio'] as int
        : int.tryParse('${json['diagnosis_ratio'] ?? ''}');
    isEmergency = json['is_emergency'] == 1 || json['is_emergency'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diagnosis_name'] = name;
    data['diagnosis_ratio'] = ratio;
    data['is_emergency'] = isEmergency;

    return data;
  }
}
