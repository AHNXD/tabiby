import '../../../center_details/data/models/centers_model.dart';
import '../../../doctor_details/data/models/doctor_model.dart';
import '../../../specialties/data/models/specialties_model.dart';
import 'promot_model.dart';

class HomeModel {
  List<Promot>? promot;
  List<SpecializationModel>? specialties;
  List<Doctor>? doctors;
  List<Centers>? centers;

  HomeModel({this.promot, this.specialties, this.doctors, this.centers});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['promot'] != null) {
      promot = <Promot>[];
      json['promot'].forEach((v) {
        promot!.add(Promot.fromJson(v));
      });
    }
    if (json['specialties'] != null) {
      specialties = <SpecializationModel>[];
      json['specialties'].forEach((v) {
        specialties!.add(SpecializationModel.fromJson(v));
      });
    }
    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
    if (json['centers'] != null) {
      centers = <Centers>[];
      json['centers'].forEach((v) {
        centers!.add(Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (promot != null) {
      data['promot'] = promot!.map((v) => v.toJson()).toList();
    }
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
