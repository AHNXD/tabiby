class RatingStatus {
  int? appointmentId;
  bool? hasRated;
  bool? canRate;
  Rating? rating;

  RatingStatus({this.appointmentId, this.hasRated, this.canRate, this.rating});

  RatingStatus.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    hasRated = json['has_rated'];
    canRate = json['can_rate'];
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointmentId;
    data['has_rated'] = hasRated;
    data['can_rate'] = canRate;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }
}

class Rating {
  int? rating;
  String? comment;

  Rating({this.rating, this.comment});

  Rating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
