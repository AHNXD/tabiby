import 'dart:io';

import 'package:equatable/equatable.dart';

enum MedicalFileType { xray, lab }

enum MedicalFilesFilter { all, xray, lab }

extension MedicalFileTypeX on MedicalFileType {
  String get labelKey =>
      this == MedicalFileType.xray ? 'xray_file' : 'lab_file';
}

extension MedicalFilesFilterX on MedicalFilesFilter {
  String get labelKey {
    switch (this) {
      case MedicalFilesFilter.all:
        return 'all_files';
      case MedicalFilesFilter.xray:
        return 'xray_file';
      case MedicalFilesFilter.lab:
        return 'lab_file';
    }
  }
}

class MedicalFile extends Equatable {
  final int id;
  final String title;
  final MedicalFileType type;
  final DateTime fileDate;
  final String? localFilePath;
  final String? remoteFileUrl;
  final DateTime createdAt;

  const MedicalFile({
    required this.id,
    required this.title,
    required this.type,
    required this.fileDate,
    required this.createdAt,
    this.localFilePath,
    this.remoteFileUrl,
  });

  File? get localFile {
    if (localFilePath == null || localFilePath!.isEmpty) {
      return null;
    }
    return File(localFilePath!);
  }

  bool matchesFilter(MedicalFilesFilter filter) {
    switch (filter) {
      case MedicalFilesFilter.all:
        return true;
      case MedicalFilesFilter.xray:
        return type == MedicalFileType.xray;
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
    localFilePath,
    remoteFileUrl,
    createdAt,
  ];
}

class CreateMedicalFileRequest {
  final String title;
  final MedicalFileType type;
  final DateTime fileDate;
  final File imageFile;

  const CreateMedicalFileRequest({
    required this.title,
    required this.type,
    required this.fileDate,
    required this.imageFile,
  });
}
