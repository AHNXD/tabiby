import '../../../specialties/data/models/specialties_model.dart';

class DoctorsModel {
  int? id;
  String? name;
  String? img;
  int? rate;
  SpecializationModel? specialties;

  DoctorsModel({this.id, this.name, this.img, this.rate, this.specialties});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    rate = json['rate'];
    specialties = json['specialties'] != null
        ? SpecializationModel.fromJson(json['specialties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['rate'] = rate;
    if (specialties != null) {
      data['specialties'] = specialties!.toJson();
    }
    return data;
  }
}
