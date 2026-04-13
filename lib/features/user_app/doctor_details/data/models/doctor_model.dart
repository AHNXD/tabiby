import '../../../../../core/models/page_info.dart';
import '../../../specialties/data/models/specialties_model.dart';

class DoctorsModel {
  PageInfo? pageInfo;
  List<Doctor>? doctors;

  DoctorsModel({this.pageInfo, this.doctors});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;

    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pageInfo != null) {
      data['page_info'] = pageInfo!.toJson();
    }
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctor {
  int? id;
  String? name;
  String? img;
  String? bio;
  String? doctorType;
  int? rate;
  int? yearsOfExperience;
  int? bookedAppointmentsCount;
  int? isActive;
  SpecializationModel? specialty;
  List<DoctorCenters>? centers;

  Doctor({
    this.id,
    this.name,
    this.img,
    this.bio,
    this.doctorType,
    this.rate,
    this.yearsOfExperience,
    this.bookedAppointmentsCount,
    this.isActive,
    this.specialty,
    this.centers,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['image'];
    bio = json['bio'];
    doctorType = json['doctor_type']?.toString();
    rate = (json['rate'] as num?)?.toInt();
    yearsOfExperience = json['experience_years'];
    bookedAppointmentsCount = (json['booked_appointments_count'] as num?)
        ?.toInt();
    isActive = json['is_active'];
    specialty = json['specialty'] != null
        ? SpecializationModel.fromJson(json['specialty'])
        : null;
    if (json['centers'] != null) {
      centers = <DoctorCenters>[];
      json['centers'].forEach((v) {
        centers!.add(DoctorCenters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = img;
    data['bio'] = bio;
    data['doctor_type'] = doctorType;
    data['rate'] = rate;
    data['experience_years'] = yearsOfExperience;
    data['booked_appointments_count'] = bookedAppointmentsCount;
    data['is_active'] = isActive;
    if (specialty != null) {
      data['specialty'] = specialty!.toJson();
    }
    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorCenters {
  int? id;
  String? name;
  String? price;
  List<int>? days;
  String? image;
  String? timeFrom;
  String? timeTo;

  DoctorCenters({
    this.id,
    this.name,
    this.price,
    this.days,
    this.image,
    this.timeFrom,
    this.timeTo,
  });

  DoctorCenters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    days = json['days'].cast<int>();
    image = json['image'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['days'] = days;
    data['image'] = image;
    data['time_from'] = timeFrom;
    data['time_to'] = timeTo;
    return data;
  }
}
