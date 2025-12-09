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
  String? img;   
  String? name;
  String? location;

  Centers({this.id, this.img, this.name, this.location});

  Centers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    name = json['name'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['img'] = img;
    data['name'] = name;
    data['location'] = location;

    return data;
  }
}
