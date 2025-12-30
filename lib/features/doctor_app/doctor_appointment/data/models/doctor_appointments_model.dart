class DoctorAppointmentsModel {
  List<DoctorAppointmentData> appointments;

  DoctorAppointmentsModel({required this.appointments});

  factory DoctorAppointmentsModel.fromJson(dynamic json) {
    List<DoctorAppointmentData> list = [];

    if (json is List) {
      list = json.map((i) => DoctorAppointmentData.fromJson(i)).toList();
    }

    return DoctorAppointmentsModel(appointments: list);
  }
}

class DoctorAppointmentData {
  int id;
  String? patientName;
  String? patientImage;
  String? status;
  String? centerName;
  String? date;
  String? time;

  DoctorAppointmentData({
    required this.id,
    this.patientName,
    this.patientImage,
    this.status,
    this.centerName,
    this.date,
    this.time,
  });

  factory DoctorAppointmentData.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentData(
      id: json['id'],
      patientName: json['patient_name'],
      patientImage: json['patient_profile'],
      status: json['status'],
      centerName: json['clinic_center_name'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'patient_profile': patientImage,
      'status': status,
      'clinic_center_name': centerName,
      'date': date,
      'time': time,
    };
  }
}
