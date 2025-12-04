// import 'promot_model.dart';

// class HomeModel {
//   List<Promot>? promot;
//   List<Specialties>? specialties;
//   List<Doctors>? doctors;
//   List<Centers>? centers;

//   HomeModel({this.promot, this.specialties, this.doctors, this.centers});

//   HomeModel.fromJson(Map<String, dynamic> json) {
//     if (json['promot'] != null) {
//       promot = <Promot>[];
//       json['promot'].forEach((v) {
//         promot!.add(new Promot.fromJson(v));
//       });
//     }
//     if (json['specialties'] != null) {
//       specialties = <Specialties>[];
//       json['specialties'].forEach((v) {
//         specialties!.add(new Specialties.fromJson(v));
//       });
//     }
//     if (json['doctors'] != null) {
//       doctors = <Doctors>[];
//       json['doctors'].forEach((v) {
//         doctors!.add(new Doctors.fromJson(v));
//       });
//     }
//     if (json['centers'] != null) {
//       centers = <Centers>[];
//       json['centers'].forEach((v) {
//         centers!.add(new Centers.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.promot != null) {
//       data['promot'] = this.promot!.map((v) => v.toJson()).toList();
//     }
//     if (this.specialties != null) {
//       data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
//     }
//     if (this.doctors != null) {
//       data['doctors'] = this.doctors!.map((v) => v.toJson()).toList();
//     }
//     if (this.centers != null) {
//       data['centers'] = this.centers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
