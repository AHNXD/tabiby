class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? birthdate;
  int? points;
  int? maxPoints;
  String? level;
  int? age;
  int? rank;
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.birthdate,
    this.points,
    this.level,
    this.age,
    this.maxPoints,
    this.rank,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    birthdate = json['birthdate'];
    points = json['points'];
    level = json['level'];
    age = json['age'];
    maxPoints = json['max_points'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['birthdate'] = birthdate;
    data['points'] = points;
    data['level'] = level;
    data['age'] = age;
    data['max_points'] = maxPoints;

    if (rank != null) {
      data['rank'] = rank!;
    }

    return data;
  }
}
