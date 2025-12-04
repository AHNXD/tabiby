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
  String? isSmoke;

  MoreInfo({
    this.address,
    this.gender,
    this.weight,
    this.height,
    this.maritalStatus,
    this.hasChildren,
    this.numberOfChildren,
    this.birthDate,
    this.isSmoke,
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

    isSmoke = json['is_smoke'];
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

    data['is_smoke'] = isSmoke;

    return data;
  }
}
