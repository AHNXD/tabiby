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
  int? durationMinutes;

  TimeSlot({this.time, this.durationMinutes});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    time = json['time']?.toString();
    durationMinutes = _readInt(json['duration_minutes']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['duration_minutes'] = durationMinutes;
    return data;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
