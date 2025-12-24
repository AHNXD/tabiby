class CentersAppointmentModel {
  List<Centers>? centers;

  CentersAppointmentModel({this.centers});

  CentersAppointmentModel.fromJson(Map<String, dynamic> json) {
    if (json['centers'] != null) {
      centers = <Centers>[];
      json['centers'].forEach((v) {
        centers!.add(Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Centers {
  int? id;
  String? name;
  String? address;
  String? price;

  Centers({this.id, this.name, this.address, this.price});

  Centers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['price'] = price;
    return data;
  }
}
