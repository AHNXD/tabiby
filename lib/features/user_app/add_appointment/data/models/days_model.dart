class DaysModel {
  List<Days>? days;

  DaysModel({this.days});

  DaysModel.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      days = <Days>[];
      json['date'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (days != null) {
      data['date'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String? date;

  Days({this.date});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    return data;
  }
}
