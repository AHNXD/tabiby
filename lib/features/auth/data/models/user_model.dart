class UserModel {
  Patient? patient;
  MoreInfo? moreInfo;

  UserModel({this.patient, this.moreInfo});

  UserModel.fromJson(Map<String, dynamic> json) {
    patient = json['patient'] != null
        ? Patient.fromJson(json['patient'])
        : null;
    moreInfo = json['more_info'] != null
        ? MoreInfo.fromJson(json['more_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    if (moreInfo != null) {
      data['more_info'] = moreInfo!.toJson();
    }
    return data;
  }
}

class Patient {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? role;

  Patient({this.id, this.firstName, this.lastName, this.phone, this.role});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['role'] = role;
    return data;
  }
}

class MoreInfo {
  String? address;
  String? gender;
  String? weight;
  String? height;
  String? maritalStatus;
  bool? hasChildren;
  String? numberOfChildren;
  String? birthDate;
  int? userId;
  String? isSmoke;
  String? updatedAt;
  String? createdAt;
  int? id;

  MoreInfo({
    this.address,
    this.gender,
    this.weight,
    this.height,
    this.maritalStatus,
    this.hasChildren,
    this.numberOfChildren,
    this.birthDate,
    this.userId,
    this.isSmoke,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  MoreInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    gender = json['gender'];
    weight = json['weight'];
    height = json['height'];
    maritalStatus = json['marital_status'];
    hasChildren = json['has_children'];
    numberOfChildren = json['number_of_children'];
    birthDate = json['birth_date'];
    userId = json['user_id'];
    isSmoke = json['is_smoke'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

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
    data['user_id'] = userId;
    data['is_smoke'] = isSmoke;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
