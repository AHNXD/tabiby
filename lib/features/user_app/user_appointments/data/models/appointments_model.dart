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

  Appointment({this.id, this.date, this.time, this.doctor, this.doctorNote});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    doctorNote = json['doctor_notes'] != null
        ? DoctorNote.fromJson(json['doctor_notes'])
        : null;
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
    return data;
  }
}

class DoctorNote {
  String? note;
  String? prescription;

  DoctorNote({this.note, this.prescription});

  DoctorNote.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    prescription = json['prescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['prescription'] = prescription;

    return data;
  }
}
