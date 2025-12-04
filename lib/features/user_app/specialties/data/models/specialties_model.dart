class SpecialtiesModel {
  List<SpecializationModel>? specializations;

  SpecialtiesModel({this.specializations});

  SpecialtiesModel.fromJson(Map<String, dynamic> json) {
    if (json['specialties'] != null) {
      specializations = <SpecializationModel>[];
      json['specialties'].forEach((v) {
        specializations!.add(SpecializationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (specializations != null) {
      data['specialties'] = specializations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecializationModel {
  int? id;
  String? name;
  String? img;

  SpecializationModel({this.id, this.name, this.img});

  SpecializationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    return data;
  }
}
