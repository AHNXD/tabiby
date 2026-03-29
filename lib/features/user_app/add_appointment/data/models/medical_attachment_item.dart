import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';

enum MedicalAttachmentType { xray, labResult }

class MedicalAttachmentItem {
  final int id;
  final String title;
  final String? subtitle;
  final String? thumbnailUrl;
  final String? fileUrl;
  final String? recordedAt;
  final MedicalAttachmentType type;

  const MedicalAttachmentItem({
    required this.id,
    required this.title,
    required this.type,
    this.subtitle,
    this.thumbnailUrl,
    this.fileUrl,
    this.recordedAt,
  });

  factory MedicalAttachmentItem.fromJson(Map<String, dynamic> json) {
    final String normalizedType = json['type']?.toString().toLowerCase() ?? '';
    return MedicalAttachmentItem(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['description']?.toString(),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ?? json['image']?.toString(),
      fileUrl: json['file_url']?.toString() ?? json['url']?.toString(),
      recordedAt:
          json['recorded_at']?.toString() ?? json['created_at']?.toString(),
      type: normalizedType == 'lab_result'
          ? MedicalAttachmentType.labResult
          : MedicalAttachmentType.xray,
    );
  }

  factory MedicalAttachmentItem.fromMedicalFile(MedicalFile file) {
    return MedicalAttachmentItem(
      id: file.id,
      title: file.title,
      subtitle: file.type == MedicalFileType.xray ? 'xray_file' : 'lab_file',
      thumbnailUrl: file.remoteFileUrl,
      fileUrl: file.localFilePath ?? file.remoteFileUrl,
      recordedAt: file.fileDate.toIso8601String(),
      type: file.type == MedicalFileType.xray
          ? MedicalAttachmentType.xray
          : MedicalAttachmentType.labResult,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'thumbnail_url': thumbnailUrl,
      'file_url': fileUrl,
      'recorded_at': recordedAt,
      'type': type == MedicalAttachmentType.xray ? 'xray' : 'lab_result',
    };
  }
}
