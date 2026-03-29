import 'package:tabiby/core/models/medical_record_attachment.dart';

class DoctorAppointmentDetailsModel {
  String? status;
  Patient? patient;
  String? note;
  Diagnose? diagnose;
  String? date;
  String? time;
  MedicalRecordAttachment? attachedXray;
  MedicalRecordAttachment? attachedLabResult;

  DoctorAppointmentDetailsModel({
    this.status,
    this.patient,
    this.note,
    this.diagnose,
    this.date,
    this.time,
    this.attachedXray,
    this.attachedLabResult,
  });

  DoctorAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    patient = json['patient'] != null
        ? Patient.fromJson(json['patient'])
        : null;
    note = json['note']?.toString();
    diagnose = json['diagnosis'] != null
        ? Diagnose.fromJson(json['diagnosis'])
        : null;
    date = json['date']?.toString();
    time = json['time']?.toString();
    attachedXray = _parseAttachment(
      mapValue: json['attached_xray'] ?? json['xray'],
      urlValue: json['xray_url'],
      fallbackTitle: 'X-Ray',
      fallbackType: 'xray',
    );
    attachedLabResult = _parseAttachment(
      mapValue: json['attached_lab_result'] ?? json['lab_result'],
      urlValue: json['lab_result_url'],
      fallbackTitle: 'Lab Result',
      fallbackType: 'lab_result',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    data['note'] = note;
    if (diagnose != null) {
      data['diagnosis'] = diagnose!.toJson();
    }
    data['date'] = date;
    data['time'] = time;
    if (attachedXray != null) {
      data['attached_xray'] = attachedXray!.toJson();
    }
    if (attachedLabResult != null) {
      data['attached_lab_result'] = attachedLabResult!.toJson();
    }
    return data;
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
