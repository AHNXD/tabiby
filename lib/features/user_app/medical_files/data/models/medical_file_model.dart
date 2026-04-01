import 'dart:io';

import 'package:equatable/equatable.dart';

enum MedicalFileType { radiology, lab }

enum MedicalFilesFilter { all, radiology, lab }

enum MedicalRecordSource {
  patientMedicalRecord,
  radiologyResult,
  labResult,
  unknown,
}

extension MedicalFileTypeX on MedicalFileType {
  String get apiValue =>
      this == MedicalFileType.radiology ? 'radiology' : 'lab';

  String get labelKey =>
      this == MedicalFileType.radiology ? 'radiology_file' : 'lab_file';

  static MedicalFileType fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'lab':
      case 'laboratory':
      case 'lab_result':
        return MedicalFileType.lab;
      case 'radiology':
      case 'xray':
      case 'x-ray':
      default:
        return MedicalFileType.radiology;
    }
  }
}

extension MedicalFilesFilterX on MedicalFilesFilter {
  String get labelKey {
    switch (this) {
      case MedicalFilesFilter.all:
        return 'all_files';
      case MedicalFilesFilter.radiology:
        return 'radiology_file';
      case MedicalFilesFilter.lab:
        return 'lab_file';
    }
  }
}

extension MedicalRecordSourceX on MedicalRecordSource {
  static MedicalRecordSource fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'patient_medical_record':
        return MedicalRecordSource.patientMedicalRecord;
      case 'radiology_result':
        return MedicalRecordSource.radiologyResult;
      case 'lab_result':
        return MedicalRecordSource.labResult;
      default:
        return MedicalRecordSource.unknown;
    }
  }
}

class MedicalImageType extends Equatable {
  final int id;
  final String name;

  const MedicalImageType({required this.id, required this.name});

  factory MedicalImageType.fromJson(Map<String, dynamic> json) {
    return MedicalImageType(
      id: _asInt(json['id']),
      name: json['name']?.toString().trim() ?? '',
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name];
}

class MedicalFile extends Equatable {
  final int id;
  final String title;
  final MedicalFileType type;
  final DateTime fileDate;
  final String? filePath;
  final String? localFilePath;
  final String? remoteFileUrl;
  final DateTime? createdAt;
  final MedicalRecordSource recordSource;
  final String? sourceLabel;

  const MedicalFile({
    required this.id,
    required this.title,
    required this.type,
    required this.fileDate,
    this.createdAt,
    this.filePath,
    this.localFilePath,
    this.remoteFileUrl,
    this.recordSource = MedicalRecordSource.unknown,
    this.sourceLabel,
  });

  factory MedicalFile.fromUploadJson(
    Map<String, dynamic> json, {
    String? localFilePath,
  }) {
    return MedicalFile(
      id: _asInt(json['id']),
      title: json['title']?.toString().trim() ?? '',
      type: MedicalFileTypeX.fromApi(json['type']?.toString()),
      fileDate: _parseDate(
        json['record_date'],
        fallback: _parseDate(json['created_at'], fallback: DateTime.now()),
      ),
      createdAt: _parseNullableDate(json['created_at']),
      filePath: _cleanString(json['file_path']),
      localFilePath: localFilePath,
      remoteFileUrl: _cleanString(json['file_url']),
      recordSource: MedicalRecordSource.patientMedicalRecord,
      sourceLabel: _cleanString(json['source_label']) ?? 'Patient Upload',
    );
  }

  factory MedicalFile.fromAllRecordsJson(Map<String, dynamic> json) {
    final MedicalRecordSource source = MedicalRecordSourceX.fromApi(
      json['record_source']?.toString(),
    );
    final MedicalFileType fallbackType = source == MedicalRecordSource.labResult
        ? MedicalFileType.lab
        : MedicalFileType.radiology;

    return MedicalFile(
      id: _asInt(json['record_id'] ?? json['id']),
      title: json['title']?.toString().trim() ?? '',
      type: MedicalFileTypeX.fromApi(
        json['type']?.toString() ?? fallbackType.apiValue,
      ),
      fileDate: _parseDate(
        json['record_date'],
        fallback: _parseDate(json['created_at'], fallback: DateTime.now()),
      ),
      createdAt: _parseNullableDate(json['created_at']),
      filePath: _cleanString(json['file_path']),
      remoteFileUrl: _cleanString(json['file_url']),
      recordSource: source,
      sourceLabel: _cleanString(json['source_label']),
    );
  }

  File? get localFile {
    if (localFilePath == null || localFilePath!.isEmpty) {
      return null;
    }
    return File(localFilePath!);
  }

  bool get hasRemoteFile => remoteFileUrl != null && remoteFileUrl!.isNotEmpty;

  bool get hasLocalFile => localFile != null && localFile!.existsSync();

  String? get fileExtension {
    final String? pathWithExtension =
        localFilePath ?? filePath ?? remoteFileUrl;
    if (pathWithExtension == null || !pathWithExtension.contains('.')) {
      return null;
    }

    final String segment = pathWithExtension.split('/').last;
    if (!segment.contains('.')) {
      return null;
    }

    return segment.split('.').last.toLowerCase();
  }

  bool get isPdf => fileExtension == 'pdf';

  bool get isImage => const <String>{
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  }.contains(fileExtension);

  String get resolvedSourceLabel {
    if (sourceLabel != null && sourceLabel!.trim().isNotEmpty) {
      return sourceLabel!.trim();
    }

    switch (recordSource) {
      case MedicalRecordSource.patientMedicalRecord:
        return 'Patient Upload';
      case MedicalRecordSource.radiologyResult:
      case MedicalRecordSource.labResult:
        return 'Appointment Result';
      case MedicalRecordSource.unknown:
        return '';
    }
  }

  bool matchesFilter(MedicalFilesFilter filter) {
    switch (filter) {
      case MedicalFilesFilter.all:
        return true;
      case MedicalFilesFilter.radiology:
        return type == MedicalFileType.radiology;
      case MedicalFilesFilter.lab:
        return type == MedicalFileType.lab;
    }
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    type,
    fileDate,
    filePath,
    localFilePath,
    remoteFileUrl,
    createdAt,
    recordSource,
    sourceLabel,
  ];
}

class CreateMedicalFileRequest {
  final String title;
  final MedicalFileType type;
  final DateTime fileDate;
  final File file;

  const CreateMedicalFileRequest({
    required this.title,
    required this.type,
    required this.fileDate,
    required this.file,
  });
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _cleanString(dynamic value) {
  final String normalized = value?.toString().trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

DateTime _parseDate(dynamic value, {required DateTime fallback}) {
  return _parseNullableDate(value) ?? fallback;
}

DateTime? _parseNullableDate(dynamic value) {
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value.toString());
}
