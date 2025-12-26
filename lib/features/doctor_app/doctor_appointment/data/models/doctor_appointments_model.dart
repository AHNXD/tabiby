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
  String? patientImage;
  String? status;
  String? date;
  String? time;

  DoctorAppointmentData({
    this.id,
    this.patientName,
    this.patientImage,
    this.status,
    this.date,
    this.time,
  });

  factory DoctorAppointmentData.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentData(
      id: json['id'],
      patientName: json['patient_name'],
      patientImage: json['patient_profile'],
      status: json['status'],
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
      'date': date,
      'time': time,
    };
  }
}