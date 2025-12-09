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
  int? rate;
  int? isActive;
  SpecializationModel? specialty;

  Doctors({
    this.id,
    this.name,
    this.img,
    this.rate,
    this.isActive,
    this.specialty,
  });

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    rate = json['rate'];
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
    data['rate'] = rate;
    data['is_active'] = isActive;
    if (specialty != null) {
      data['specialty'] = specialty!.toJson();
    }
    return data;
  }
}