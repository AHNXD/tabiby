import 'dart:convert';

import '../../../user_app/add_appointment/data/models/centers_appointment_model.dart';

class UserModel {
  MainData? mainData;
  MoreData? moreData;

  UserModel({this.mainData, this.moreData});

  UserModel.fromJson(Map<String, dynamic> json) {
    mainData = json['main_data'] != null
        ? MainData.fromJson(json['main_data'])
        : null;
    moreData = json['more_data'] != null
        ? MoreData.fromJson(json['more_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainData != null) {
      data['main_data'] = mainData!.toJson();
    }
    if (moreData != null) {
      data['more_data'] = moreData!.toJson();
    }
    return data;
  }
}

class MainData {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? role;
  List<Centers>? centers;

  MainData({
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.role,
    this.centers,
  });

  MainData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['profile_image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    role = json['role'];

    if (json['centers'] != null) {
      centers = <Centers>[];
      json['centers'].forEach((v) {
        centers!.add(Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile_image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['role'] = role;

    if (centers != null) {
      data['centers'] = centers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MoreData {
  String? address;
  String? gender;
  String? weight;
  String? height;
  String? maritalStatus;
  bool? hasChildren;
  String? numberOfChildren;
  String? birthDate;
  bool? isSmoke;
  List<String> chronicDiseases;
  List<String> permanentMedications;
  List<String> foodAllergies;
  List<String> preferredFoods;
  List<String> dislikedFoods;
  List<String> digestionIssues;

  MoreData({
    this.address,
    this.gender,
    this.weight,
    this.height,
    this.maritalStatus,
    this.hasChildren,
    this.numberOfChildren,
    this.birthDate,
    this.isSmoke,
    this.chronicDiseases = const <String>[],
    this.permanentMedications = const <String>[],
    this.foodAllergies = const <String>[],
    this.preferredFoods = const <String>[],
    this.dislikedFoods = const <String>[],
    this.digestionIssues = const <String>[],
  });

  MoreData.fromJson(Map<String, dynamic> json)
    : address = json['address']?.toString(),
      gender = json['gender']?.toString(),
      weight = json['weight']?.toString(),
      height = json['height']?.toString(),
      maritalStatus = json['marital_status']?.toString(),
      hasChildren = json['has_children'],
      numberOfChildren = json['number_of_children']?.toString(),
      birthDate = json['birth_date']?.toString(),
      isSmoke = json['is_smoke'].toString() == "1" || json['is_smoke'] == true,
      chronicDiseases = _parseStringList(json['chronic_diseases']),
      permanentMedications = _parseStringList(json['permanent_medications']),
      foodAllergies = _parseStringList(json['food_allergies']),
      preferredFoods = _parseStringList(json['preferred_foods']),
      dislikedFoods = _parseStringList(json['disliked_foods']),
      digestionIssues = _parseStringList(json['digestion_issues']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['gender'] = gender;
    data['weight'] = weight;
    data['height'] = height;
    data['marital_status'] = maritalStatus;
    data['has_children'] = hasChildren;
    data['number_of_children'] = numberOfChildren;
    data['birth_date'] = birthDate;
    data['is_smoke'] = isSmoke;
    data['chronic_diseases'] = chronicDiseases;
    data['permanent_medications'] = permanentMedications;
    data['food_allergies'] = foodAllergies;
    data['preferred_foods'] = preferredFoods;
    data['disliked_foods'] = dislikedFoods;
    data['digestion_issues'] = digestionIssues;
    return data;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) {
        return const <String>[];
      }

      try {
        final dynamic decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return decoded
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList();
        }
      } catch (_) {}

      return trimmed
          .split(RegExp(r'[\n,]'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return const <String>[];
  }
}
