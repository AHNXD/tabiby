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
  int? id;
  String? patientName;
  String? status;
  String? date;
  String? time;

  DoctorAppointmentData({
    this.id,
    this.patientName,
    this.status,
    this.date,
    this.time,
  });

  factory DoctorAppointmentData.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentData(
      id: json['id'],
      patientName: json['patient_name'], // Matches Postman key
      status: json['status'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'status': status,
      'date': date,
      'time': time,
    };
  }
}