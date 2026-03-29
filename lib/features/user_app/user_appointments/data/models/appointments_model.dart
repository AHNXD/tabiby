import 'dart:convert';

import 'package:tabiby/core/models/medical_record_attachment.dart';
import 'package:tabiby/core/models/prescription_item.dart';

import '../../../doctor_details/data/models/doctor_model.dart';

class Appointments {
  List<Appointment>? completed;
  List<Appointment>? pending;
  List<Appointment>? canceled;

  Appointments({this.completed, this.pending, this.canceled});

  Appointments.fromJson(Map<String, dynamic> json) {
    if (json['completed'] != null) {
      completed = <Appointment>[];
      json['completed'].forEach((v) {
        completed!.add(Appointment.fromJson(v));
      });
    }
    if (json['pending'] != null) {
      pending = <Appointment>[];
      json['pending'].forEach((v) {
        pending!.add(Appointment.fromJson(v));
      });
    }
    if (json['canceled'] != null) {
      canceled = <Appointment>[];
      json['canceled'].forEach((v) {
        canceled!.add(Appointment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completed != null) {
      data['completed'] = completed!.map((v) => v.toJson()).toList();
    }
    if (pending != null) {
      data['pending'] = pending!.map((v) => v.toJson()).toList();
    }
    if (canceled != null) {
      data['canceled'] = canceled!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Appointment {
  int? id;
  String? date;
  String? time;
  Doctor? doctor;
  DoctorNote? doctorNote;
  MedicalRecordAttachment? xrayAttachment;
  MedicalRecordAttachment? labResultAttachment;

  Appointment({
    this.id,
    this.date,
    this.time,
    this.doctor,
    this.doctorNote,
    this.xrayAttachment,
    this.labResultAttachment,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    doctorNote = json['doctor_notes'] != null
        ? DoctorNote.fromJson(json['doctor_notes'])
        : null;
    xrayAttachment = _parseAttachment(
      mapValue: json['xray'],
      urlValue: json['xray_url'],
      fallbackTitle: 'X-Ray',
      fallbackType: 'xray',
    );
    labResultAttachment = _parseAttachment(
      mapValue: json['lab_result'],
      urlValue: json['lab_result_url'],
      fallbackTitle: 'Lab Result',
      fallbackType: 'lab_result',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['time'] = time;
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    if (doctorNote != null) {
      data['doctor_notes'] = doctorNote!.toJson();
    }
    if (xrayAttachment != null) {
      data['xray'] = xrayAttachment!.toJson();
    }
    if (labResultAttachment != null) {
      data['lab_result'] = labResultAttachment!.toJson();
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

class DoctorNote {
  String? note;
  String? prescription;
  List<PrescriptionItem> prescriptionList;

  DoctorNote({this.note, this.prescription, this.prescriptionList = const []});

  DoctorNote.fromJson(Map<String, dynamic> json)
    : note = json['note']?.toString(),
      prescription = json['prescription']?.toString(),
      prescriptionList = _parsePrescriptionList(
        json['prescription_list'] ?? json['prescriptions'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['prescription'] = prescription;
    data['prescription_list'] = prescriptionList
        .map((v) => v.toJson())
        .toList();
    return data;
  }

  static List<PrescriptionItem> _parsePrescriptionList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) =>
                PrescriptionItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map(
                (item) =>
                    PrescriptionItem.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
      } catch (_) {}
    }

    return const <PrescriptionItem>[];
  }
}
