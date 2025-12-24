class TimesModel {
  Periods? periods;

  TimesModel({this.periods});

  TimesModel.fromJson(Map<String, dynamic> json) {
    periods = json['periods'] != null
        ? Periods.fromJson(json['periods'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (periods != null) {
      data['periods'] = periods!.toJson();
    }
    return data;
  }
}

class Periods {
  List<TimeSlot>? morning;
  List<TimeSlot>? afternoon;
  List<TimeSlot>? evening;

  Periods({this.morning, this.afternoon, this.evening});

  Periods.fromJson(Map<String, dynamic> json) {
    if (json['morning'] != null) {
      morning = <TimeSlot>[];
      json['morning'].forEach((v) {
        morning!.add(TimeSlot.fromJson(v));
      });
    }
    if (json['afternoon'] != null) {
      afternoon = <TimeSlot>[];
      json['afternoon'].forEach((v) {
        afternoon!.add(TimeSlot.fromJson(v));
      });
    }
    if (json['evening'] != null) {
      evening = <TimeSlot>[];
      json['evening'].forEach((v) {
        evening!.add(TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (morning != null) {
      data['morning'] = morning!.map((v) => v.toJson()).toList();
    }
    if (afternoon != null) {
      data['afternoon'] = afternoon!.map((v) => v.toJson()).toList();
    }
    if (evening != null) {
      data['evening'] = evening!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  String? time;

  TimeSlot({this.time});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    return data;
  }
}
