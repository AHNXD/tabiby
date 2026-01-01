class DoctorAppointmentDetailsModel {
  String? status;
  Patient? patient;
  String? note;
  String? diagnose;
  String? date;
  String? time;

  DoctorAppointmentDetailsModel({
    this.status,
    this.patient,
    this.note,
    this.diagnose,
    this.date,
    this.time,
  });

  DoctorAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    patient = json['patient'] != null
        ? Patient.fromJson(json['patient'])
        : null;
    note = json['note']?.toString();
    diagnose = json['diagnose']?.toString();
    date = json['date']?.toString();
    time = json['time']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    data['note'] = note;
    data['diagnose'] = diagnose;
    data['date'] = date;
    data['time'] = time;
    return data;
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
    height = json['height'];
    weight = json['weight'];
    hasChildren = json['has_children'];
    numberOfChildren = json['number_of_children'];
    birthDate = json['birth_date'];
    smoker = json['smoker'];
    maritalStatus = json['marital_status'];
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
}
