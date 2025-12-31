import '../../../../../core/models/page_info.dart';

class CentersModel {
  PageInfo? pageInfo;
  List<Centers>? centers;

  CentersModel({this.pageInfo, this.centers});

  CentersModel.fromJson(Map<String, dynamic> json) {
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;

    if (json['centers'] != null) {
      centers = <Centers>[];
      json['centers'].forEach((v) {
        centers!.add(Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (pageInfo != null) {
      data['page_info'] = pageInfo!.toJson();
    }

    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Centers {
  int? id;
  String? name;
  String? img;
  String? address;
  String? bio;
  List<Clinics>? clinics;

  Centers({this.id, this.name, this.img, this.address, this.bio, this.clinics});

  Centers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    address = json['address'];
    bio = json['bio'];
    if (json['clinics'] != null) {
      clinics = <Clinics>[];
      json['clinics'].forEach((v) {
        clinics!.add(Clinics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    data['address'] = address;
    data['bio'] = bio;
    if (clinics != null) {
      data['clinics'] = clinics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinics {
  int? id;
  String? name;
  String? image;
  Clinics({this.id, this.name, this.image});

  Clinics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
