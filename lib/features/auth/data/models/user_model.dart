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
  String? bloodType;
  bool? hasChildren;
  String? numberOfChildren;
  String? birthDate;
  bool? isSmoke;
  String? chronicDiseases;
  String? permanentMedications;
  String? foodAllergies;
  String? favoriteFoods;
  String? dislikedFoods;
  String? digestionIssues;

  MoreData({
    this.address,
    this.gender,
    this.weight,
    this.height,
    this.maritalStatus,
    this.bloodType,
    this.hasChildren,
    this.numberOfChildren,
    this.birthDate,
    this.isSmoke,
    this.chronicDiseases,
    this.permanentMedications,
    this.foodAllergies,
    this.favoriteFoods,
    this.dislikedFoods,
    this.digestionIssues,
  });

  MoreData.fromJson(Map<String, dynamic> json)
    : address = json['address']?.toString(),
      gender = json['gender']?.toString(),
      weight = json['weight']?.toString(),
      height = json['height']?.toString(),
      maritalStatus = json['marital_status']?.toString(),
      bloodType = json['blood_type']?.toString(),
      hasChildren = _parseBool(json['has_children']),
      numberOfChildren = json['number_of_children']?.toString(),
      birthDate = json['birth_date']?.toString(),
      isSmoke = _parseBool(json['is_smoke']),
      chronicDiseases = _parseFlexibleString(json['chronic_diseases']),
      permanentMedications = _parseFlexibleString(
        json['permanent_medications'],
      ),
      foodAllergies = _parseFlexibleString(json['food_allergies']),
      favoriteFoods = _parseFlexibleString(
        json['favorite_foods'] ?? json['preferred_foods'],
      ),
      dislikedFoods = _parseFlexibleString(json['disliked_foods']),
      digestionIssues = _parseFlexibleString(json['digestion_issues']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['gender'] = gender;
    data['weight'] = weight;
    data['height'] = height;
    data['marital_status'] = maritalStatus;
    data['blood_type'] = bloodType;
    data['has_children'] = hasChildren;
    data['number_of_children'] = numberOfChildren;
    data['birth_date'] = birthDate;
    data['is_smoke'] = isSmoke;
    data['chronic_diseases'] = chronicDiseases;
    data['permanent_medications'] = permanentMedications;
    data['food_allergies'] = foodAllergies;
    data['favorite_foods'] = favoriteFoods;
    data['disliked_foods'] = dislikedFoods;
    data['digestion_issues'] = digestionIssues;
    return data;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    final String normalized = value.toString().trim().toLowerCase();
    if (normalized == '1' || normalized == 'true') {
      return true;
    }
    if (normalized == '0' || normalized == 'false') {
      return false;
    }

    return null;
  }

  static String? _parseFlexibleString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is List) {
      final String joined = value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(', ');
      return joined.isEmpty ? null : joined;
    }

    if (value is String) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }

      try {
        final dynamic decoded = jsonDecode(trimmed);
        if (decoded is List) {
          final String joined = decoded
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .join(', ');
          return joined.isEmpty ? null : joined;
        }
      } catch (_) {}

      return trimmed;
    }

    final String fallback = value.toString().trim();
    return fallback.isEmpty ? null : fallback;
  }
}
