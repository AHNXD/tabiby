import '../../../../../core/models/page_info.dart';
import '../../../specialties/data/models/specialties_model.dart';

class DoctorsModel {
  PageInfo? pageInfo;
  List<Doctor>? doctors;

  DoctorsModel({this.pageInfo, this.doctors});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;

    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pageInfo != null) {
      data['page_info'] = pageInfo!.toJson();
    }
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctor {
  int? id;
  String? name;
  String? img;
  String? bio;
  String? doctorType;
  int? rate;
  int? yearsOfExperience;
  int? bookedAppointmentsCount;
  int? isActive;
  SpecializationModel? specialty;
  List<DoctorCenters>? centers;

  Doctor({
    this.id,
    this.name,
    this.img,
    this.bio,
    this.doctorType,
    this.rate,
    this.yearsOfExperience,
    this.bookedAppointmentsCount,
    this.isActive,
    this.specialty,
    this.centers,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['image'];
    bio = json['bio'];
    doctorType = json['doctor_type']?.toString();
    rate = (json['rate'] as num?)?.toInt();
    yearsOfExperience = json['experience_years'];
    bookedAppointmentsCount = (json['booked_appointments_count'] as num?)
        ?.toInt();
    isActive = json['is_active'];
    specialty = json['specialty'] != null
        ? SpecializationModel.fromJson(json['specialty'])
        : null;
    if (json['centers'] != null) {
      centers = <DoctorCenters>[];
      json['centers'].forEach((v) {
        centers!.add(DoctorCenters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = img;
    data['bio'] = bio;
    data['doctor_type'] = doctorType;
    data['rate'] = rate;
    data['experience_years'] = yearsOfExperience;
    data['booked_appointments_count'] = bookedAppointmentsCount;
    data['is_active'] = isActive;
    if (specialty != null) {
      data['specialty'] = specialty!.toJson();
    }
    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorCenters {
  int? id;
  String? name;
  String? price;
  List<int>? days;
  List<DoctorCenterDay>? daySchedules;
  String? image;
  String? timeFrom;
  String? timeTo;
  int? appointmentDurationMinutes;

  DoctorCenters({
    this.id,
    this.name,
    this.price,
    this.days,
    this.daySchedules,
    this.image,
    this.timeFrom,
    this.timeTo,
    this.appointmentDurationMinutes,
  });

  DoctorCenters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']?.toString();
    image = json['image'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    appointmentDurationMinutes = _readInt(json['appointment_duration_minutes']);

    final rawDays = json['days'];
    if (rawDays is List) {
      daySchedules = rawDays
          .whereType<Map>()
          .map(
            (day) => DoctorCenterDay.fromJson(
              day.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList();

      days = rawDays
          .map((day) {
            if (day is Map) return _readInt(day['day_of_week']);
            return _readInt(day);
          })
          .whereType<int>()
          .toList();
    }

    final rawDayNumbers = json['day_numbers'];
    if (rawDayNumbers is List) {
      days = rawDayNumbers.map(_readInt).whereType<int>().toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['days'] = daySchedules?.map((v) => v.toJson()).toList() ?? days;
    data['day_numbers'] = days;
    data['image'] = image;
    data['time_from'] = timeFrom;
    data['time_to'] = timeTo;
    data['appointment_duration_minutes'] = appointmentDurationMinutes;
    return data;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class DoctorCenterDay {
  int? dayOfWeek;
  String? timeFrom;
  String? timeTo;
  int? appointmentDurationMinutes;

  DoctorCenterDay({
    this.dayOfWeek,
    this.timeFrom,
    this.timeTo,
    this.appointmentDurationMinutes,
  });

  DoctorCenterDay.fromJson(Map<String, dynamic> json) {
    dayOfWeek = DoctorCenters._readInt(json['day_of_week']);
    timeFrom = json['time_from']?.toString();
    timeTo = json['time_to']?.toString();
    appointmentDurationMinutes = DoctorCenters._readInt(
      json['appointment_duration_minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day_of_week'] = dayOfWeek;
    data['time_from'] = timeFrom;
    data['time_to'] = timeTo;
    data['appointment_duration_minutes'] = appointmentDurationMinutes;
    return data;
  }
}
