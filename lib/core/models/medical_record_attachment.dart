class MedicalRecordAttachment {
  final int? id;
  final String title;
  final String? url;
  final String? thumbnailUrl;
  final String? type;

  const MedicalRecordAttachment({
    this.id,
    required this.title,
    this.url,
    this.thumbnailUrl,
    this.type,
  });

  factory MedicalRecordAttachment.fromJson(
    Map<String, dynamic> json, {
    String? fallbackTitle,
    String? fallbackType,
  }) {
    return MedicalRecordAttachment(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          fallbackTitle ??
          '',
      url:
          json['url']?.toString() ??
          json['file_url']?.toString() ??
          json['xray_url']?.toString() ??
          json['lab_result_url']?.toString(),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ??
          json['image']?.toString() ??
          json['preview_url']?.toString(),
      type: json['type']?.toString() ?? fallbackType,
    );
  }

  factory MedicalRecordAttachment.fromUrl(
    String? url, {
    required String fallbackTitle,
    required String fallbackType,
    int? id,
  }) {
    return MedicalRecordAttachment(
      id: id,
      title: fallbackTitle,
      url: url,
      thumbnailUrl: url,
      type: fallbackType,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'type': type,
    };
  }
}
