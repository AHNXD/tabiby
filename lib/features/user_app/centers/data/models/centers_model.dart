class CentersModel {
  int? id;
  String? name;
  String? address;

  CentersModel({this.id, this.name, this.address});

  CentersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    return data;
  }
}
