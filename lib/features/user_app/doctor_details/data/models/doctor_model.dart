import '../../../../../core/models/page_info.dart';
import '../../../specialties/data/models/specialties_model.dart';

class DoctorsModel {
  PageInfo? pageInfo;
  List<Doctors>? doctors;

  DoctorsModel({this.pageInfo, this.doctors});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;

    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctors.fromJson(v));
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

class Doctors {
  int? id;
  String? name;
  String? img;
  String? bio;
  int? rate;
  int? yearsOfExperience;
  int? isActive;
  SpecializationModel? specialty;

  Doctors({
    this.id,
    this.name,
    this.img,
    this.bio,
    this.rate,
    this.yearsOfExperience,
    this.isActive,
    this.specialty,
  });

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    bio = json['bio'];
    rate = json['rate'];
    yearsOfExperience = json['years_of_experience'];
    isActive = json['is_active'];
    specialty = json['specialty'] != null
        ? SpecializationModel.fromJson(json['specialty'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['bio'] = bio;
    data['rate'] = rate;
    data['years_of_experience'] = yearsOfExperience;
    data['is_active'] = isActive;
    if (specialty != null) {
      data['specialty'] = specialty!.toJson();
    }
    return data;
  }
}
