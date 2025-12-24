import '../../../doctor_details/data/models/doctor_model.dart';

class Appointments {
  List<Appointment>? finished;
  List<Appointment>? pending;
  List<Appointment>? canceled;

  Appointments({this.finished, this.pending, this.canceled});

  Appointments.fromJson(Map<String, dynamic> json) {
    if (json['finished'] != null) {
      finished = <Appointment>[];
      json['finished'].forEach((v) {
        finished!.add(Appointment.fromJson(v));
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
    if (finished != null) {
      data['finished'] = finished!.map((v) => v.toJson()).toList();
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

  Appointment({this.id, this.date, this.time, this.doctor});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['time'] = time;
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}
