import 'package:tabiby/core/models/medical_record_attachment.dart';
import 'package:tabiby/core/models/prescription_item.dart';

class AppointmentDetailsModel {
  final int? id;
  final String? type;
  final String? status;
  final String? date;
  final String? time;
  final double? price;
  final String? patientNote;
  final String? doctorNote;
  final AppointmentDiagnosisDetails? diagnosis;
  final AppointmentSelectedItem? selectedRadiologyImageType;
  final List<AppointmentSelectedItem> selectedLabTests;
  final bool? hasPharmacy;
  final bool? sendToPharmacy;
  final AppointmentPersonDetails? patient;
  final AppointmentDoctorDetails? doctor;
  final List<PrescriptionItem> prescriptionItems;
  final List<AppointmentNamedRequest> labRequests;
  final List<AppointmentNamedRequest> radiologyRequests;
  final AppointmentResultFile? radiologyResult;
  final AppointmentResultFile? labResult;
  final List<MedicalRecordAttachment> attachedMedicalRecords;

  const AppointmentDetailsModel({
    this.id,
    this.type,
    this.status,
    this.date,
    this.time,
    this.price,
    this.patientNote,
    this.doctorNote,
    this.diagnosis,
    this.selectedRadiologyImageType,
    this.selectedLabTests = const <AppointmentSelectedItem>[],
    this.hasPharmacy,
    this.sendToPharmacy,
    this.patient,
    this.doctor,
    this.prescriptionItems = const <PrescriptionItem>[],
    this.labRequests = const <AppointmentNamedRequest>[],
    this.radiologyRequests = const <AppointmentNamedRequest>[],
    this.radiologyResult,
    this.labResult,
    this.attachedMedicalRecords = const <MedicalRecordAttachment>[],
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsModel(
      id: _asNullableInt(json['id']),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      price: _asNullableDouble(json['price']),
      patientNote: json['patient_note']?.toString(),
      doctorNote: json['doctor_note']?.toString(),
      diagnosis: json['diagnosis'] is Map<String, dynamic>
          ? AppointmentDiagnosisDetails.fromJson(
              json['diagnosis'] as Map<String, dynamic>,
            )
          : null,
      selectedRadiologyImageType:
          json['selected_radiology_image_type'] is Map<String, dynamic>
          ? AppointmentSelectedItem.fromJson(
              json['selected_radiology_image_type'] as Map<String, dynamic>,
              idKeys: const <String>['type_of_medical_image_id', 'id'],
              titleKeys: const <String>['type_name', 'name'],
            )
          : null,
      selectedLabTests: _parseList(
        json['selected_lab_tests'],
        (Map<String, dynamic> item) => AppointmentSelectedItem.fromJson(
          item,
          idKeys: const <String>['lab_test_id', 'id'],
          titleKeys: const <String>['name', 'type_name'],
        ),
      ),
      hasPharmacy: _asNullableBool(json['has_pharmacy']),
      sendToPharmacy: _asNullableBool(json['send_to_pharmacy']),
      patient: json['patient'] is Map<String, dynamic>
          ? AppointmentPersonDetails.fromJson(
              json['patient'] as Map<String, dynamic>,
            )
          : null,
      doctor: json['doctor'] is Map<String, dynamic>
          ? AppointmentDoctorDetails.fromJson(
              json['doctor'] as Map<String, dynamic>,
            )
          : null,
      prescriptionItems: _parseList(
        json['prescription_items'],
        (Map<String, dynamic> item) => PrescriptionItem.fromJson(item),
      ),
      labRequests: _parseList(
        json['lab_requests'],
        (Map<String, dynamic> item) =>
            AppointmentNamedRequest.fromJson(item, titleKey: 'name'),
      ),
      radiologyRequests: _parseList(
        json['radiology_requests'],
        (Map<String, dynamic> item) =>
            AppointmentNamedRequest.fromJson(item, titleKey: 'type_name'),
      ),
      radiologyResult: json['radiology_result'] is Map<String, dynamic>
          ? AppointmentResultFile.fromJson(
              json['radiology_result'] as Map<String, dynamic>,
              fileUrlKeys: const <String>['image_url', 'file_url', 'url'],
            )
          : null,
      labResult: json['lab_result'] is Map<String, dynamic>
          ? AppointmentResultFile.fromJson(
              json['lab_result'] as Map<String, dynamic>,
              fileUrlKeys: const <String>['result_file_url', 'file_url', 'url'],
            )
          : null,
      attachedMedicalRecords:
          _parseList(
            json['attached_medical_records'],
            (Map<String, dynamic> item) =>
                MedicalRecordAttachment.fromJson(item),
          ).where((MedicalRecordAttachment attachment) {
            final String? url = attachment.url;
            return url != null && url.isNotEmpty;
          }).toList(),
    );
  }

  bool get hasCompletionContent =>
      status == 'completed' &&
      ((doctorNote ?? '').trim().isNotEmpty ||
          prescriptionItems.isNotEmpty ||
          labRequests.isNotEmpty ||
          radiologyRequests.isNotEmpty ||
          radiologyResult != null ||
          labResult != null ||
          (hasPharmacy == true));

  bool get hasSelectedBookingServices =>
      selectedRadiologyImageType != null || selectedLabTests.isNotEmpty;

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (value is! List<dynamic>) {
      return <T>[];
    }

    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
}

class AppointmentPersonDetails {
  final String? image;
  final String? fullName;
  final String? gender;
  final int? height;
  final int? weight;
  final bool? hasChildren;
  final int? numberOfChildren;
  final String? birthDate;
  final bool? smoker;
  final String? maritalStatus;

  const AppointmentPersonDetails({
    this.image,
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

  factory AppointmentPersonDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentPersonDetails(
      image: json['image']?.toString(),
      fullName: json['full_name']?.toString(),
      gender: json['gender']?.toString(),
      height: _asNullableInt(json['height']),
      weight: _asNullableInt(json['weight']),
      hasChildren: _asNullableBool(json['has_children']),
      numberOfChildren: _asNullableInt(json['number_of_children']),
      birthDate: json['birth_date']?.toString(),
      smoker: _asNullableBool(json['smoker']),
      maritalStatus: json['marital_status']?.toString(),
    );
  }
}

class AppointmentDoctorDetails {
  final int? id;
  final String? fullName;
  final String? image;
  final String? specialization;

  const AppointmentDoctorDetails({
    this.id,
    this.fullName,
    this.image,
    this.specialization,
  });

  factory AppointmentDoctorDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDoctorDetails(
      id: _asNullableInt(json['id']),
      fullName: json['full_name']?.toString(),
      image: json['image']?.toString(),
      specialization: json['specialization']?.toString(),
    );
  }
}

class AppointmentDiagnosisDetails {
  final int? diagnosisRatio;
  final String? diagnosisName;
  final bool? isEmergency;

  const AppointmentDiagnosisDetails({
    this.diagnosisRatio,
    this.diagnosisName,
    this.isEmergency,
  });

  factory AppointmentDiagnosisDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDiagnosisDetails(
      diagnosisRatio: _asNullableInt(json['diagnosis_ratio']),
      diagnosisName: json['diagnosis_name']?.toString(),
      isEmergency: _asNullableBool(json['is_emergency']),
    );
  }
}

class AppointmentSelectedItem {
  final int? id;
  final String title;

  const AppointmentSelectedItem({this.id, required this.title});

  factory AppointmentSelectedItem.fromJson(
    Map<String, dynamic> json, {
    required List<String> idKeys,
    required List<String> titleKeys,
  }) {
    return AppointmentSelectedItem(
      id: _firstNullableInt(json, idKeys),
      title: _firstString(json, titleKeys),
    );
  }
}

class AppointmentNamedRequest {
  final String title;
  final String notes;

  const AppointmentNamedRequest({required this.title, required this.notes});

  factory AppointmentNamedRequest.fromJson(
    Map<String, dynamic> json, {
    required String titleKey,
  }) {
    return AppointmentNamedRequest(
      title: json[titleKey]?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }
}

class AppointmentResultFile {
  final String? fileUrl;
  final String? notes;

  const AppointmentResultFile({this.fileUrl, this.notes});

  factory AppointmentResultFile.fromJson(
    Map<String, dynamic> json, {
    required List<String> fileUrlKeys,
  }) {
    String? fileUrl;
    for (final String key in fileUrlKeys) {
      final String? candidate = json[key]?.toString();
      if (candidate != null && candidate.isNotEmpty) {
        fileUrl = candidate;
        break;
      }
    }

    return AppointmentResultFile(
      fileUrl: fileUrl,
      notes: json['notes']?.toString(),
    );
  }

  bool get hasFile => (fileUrl ?? '').isNotEmpty;

  bool get isPdf {
    final String lowerUrl = (fileUrl ?? '').toLowerCase();
    return lowerUrl.endsWith('.pdf');
  }
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

bool? _asNullableBool(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }

  final String normalized = value.toString().trim().toLowerCase();
  if (normalized == '1' || normalized == 'true') {
    return true;
  }
  if (normalized == '0' || normalized == 'false') {
    return false;
  }
  return null;
}

int? _firstNullableInt(Map<String, dynamic> json, List<String> keys) {
  for (final String key in keys) {
    final int? value = _asNullableInt(json[key]);
    if (value != null) {
      return value;
    }
  }

  return null;
}

String _firstString(Map<String, dynamic> json, List<String> keys) {
  for (final String key in keys) {
    final String value = json[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) {
      return value;
    }
  }

  return '';
}
