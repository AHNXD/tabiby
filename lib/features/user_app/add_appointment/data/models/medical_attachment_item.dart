import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';

enum MedicalAttachmentType { radiology, lab }

class MedicalAttachmentItem {
  final int id;
  final String title;
  final String? subtitle;
  final String? sourceLabel;
  final String? thumbnailUrl;
  final String? fileUrl;
  final String? recordedAt;
  final MedicalAttachmentType type;
  final String recordSource;

  const MedicalAttachmentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.recordSource,
    this.subtitle,
    this.sourceLabel,
    this.thumbnailUrl,
    this.fileUrl,
    this.recordedAt,
  });

  String get selectionKey => '$recordSource-$id';

  factory MedicalAttachmentItem.fromJson(Map<String, dynamic> json) {
    final String normalizedType = json['type']?.toString().toLowerCase() ?? '';
    return MedicalAttachmentItem(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['description']?.toString(),
      sourceLabel: json['source_label']?.toString(),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ?? json['image']?.toString(),
      fileUrl: json['file_url']?.toString() ?? json['url']?.toString(),
      recordedAt:
          json['recorded_at']?.toString() ?? json['created_at']?.toString(),
      type: normalizedType == 'lab' || normalizedType == 'lab_result'
          ? MedicalAttachmentType.lab
          : MedicalAttachmentType.radiology,
      recordSource:
          json['record_source']?.toString() ??
          (normalizedType == 'lab_result'
              ? 'lab_result'
              : 'patient_medical_record'),
    );
  }

  factory MedicalAttachmentItem.fromMedicalFile(MedicalFile file) {
    return MedicalAttachmentItem(
      id: file.id,
      title: file.title,
      subtitle: file.type == MedicalFileType.radiology
          ? 'radiology_file'
          : 'lab_file',
      sourceLabel: file.resolvedSourceLabel,
      thumbnailUrl: file.isImage ? file.remoteFileUrl : null,
      fileUrl: file.localFilePath ?? file.remoteFileUrl,
      recordedAt: file.fileDate.toIso8601String(),
      type: file.type == MedicalFileType.radiology
          ? MedicalAttachmentType.radiology
          : MedicalAttachmentType.lab,
      recordSource: _recordSourceToApiValue(file.recordSource),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'source_label': sourceLabel,
      'thumbnail_url': thumbnailUrl,
      'file_url': fileUrl,
      'recorded_at': recordedAt,
      'type': type == MedicalAttachmentType.radiology ? 'radiology' : 'lab',
      'record_source': recordSource,
    };
  }
}

String _recordSourceToApiValue(MedicalRecordSource source) {
  switch (source) {
    case MedicalRecordSource.patientMedicalRecord:
      return 'patient_medical_record';
    case MedicalRecordSource.radiologyResult:
      return 'radiology_result';
    case MedicalRecordSource.labResult:
      return 'lab_result';
    case MedicalRecordSource.unknown:
      return 'patient_medical_record';
  }
}
