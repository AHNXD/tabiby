class Promot {
  String? img;
  String? information;

  Promot({this.img, this.information});

  Promot.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    information = json['information'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['img'] = img;
    data['information'] = information;
    return data;
  }
}
