class Promot {
  String? img;
  String? information;

  Promot({this.img, this.information});

  Promot.fromJson(Map<String, dynamic> json) {
    img = json['image'];
    information = json['information'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = img;
    data['information'] = information;
    return data;
  }
}
