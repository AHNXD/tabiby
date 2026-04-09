import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/medical_file_model.dart';
import 'medical_files_repo.dart';

class MedicalFilesRepoIplm implements MedicalFilesRepo {
  MedicalFilesRepoIplm(this._apiServices, this._dio);

  final ApiServices _apiServices;
  final Dio _dio;

  final List<MedicalFile> _cachedMedicalFiles = <MedicalFile>[];
  final List<MedicalImageType> _cachedMedicalImageTypes = <MedicalImageType>[];

  @override
  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  ) async {
    try {
      final String fileName = request.file.path.split('/').last;
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'type': request.type.apiValue,
        'title': request.title.trim(),
        'record_date': DateFormat('yyyy-MM-dd').format(request.fileDate),
        'file': await MultipartFile.fromFile(
          request.file.path,
          filename: fileName,
        ),
      });

      final Response<dynamic> resp = await _apiServices.post(
        endPoint: Urls.uploadPatientMedicalRecord,
        data: formData,
      );

      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300 &&
          resp.data['status'] == true &&
          resp.data['data'] is Map<String, dynamic>) {
        final MedicalFile file = MedicalFile.fromUploadJson(
          resp.data['data'] as Map<String, dynamic>,
          localFilePath: request.file.path,
        );

        _upsertCachedFile(file);
        return right(file);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, String>> downloadMedicalFileToTemp(
    MedicalFile file,
  ) async {
    try {
      if (file.localFile != null && file.localFile!.existsSync()) {
        return right(file.localFile!.path);
      }

      if (!file.hasRemoteFile) {
        return left(const ServerFailure(ErrorHandler.errorTryAgain));
      }

      final Directory targetDirectory = Directory(
        '${Directory.systemTemp.path}/tabiby_medical_files',
      );
      if (!targetDirectory.existsSync()) {
        targetDirectory.createSync(recursive: true);
      }

      final String targetPath =
          '${targetDirectory.path}/${_buildDownloadFileName(file)}';

      await _dio.download(Urls.fixUrl(file.remoteFileUrl!), targetPath);

      return right(targetPath);
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  List<MedicalImageType> getCachedMedicalImageTypes() {
    return List<MedicalImageType>.unmodifiable(_cachedMedicalImageTypes);
  }

  @override
  List<MedicalFile> getCachedMedicalFiles() {
    return List<MedicalFile>.unmodifiable(_cachedMedicalFiles);
  }

  @override
  Future<Either<Failure, List<MedicalImageType>>> getMedicalImageTypes() async {
    try {
      final Response<dynamic> resp = await _apiServices.get(
        endPoint: Urls.medicalImageTypes,
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List) {
        final List<MedicalImageType> types =
            (resp.data['data'] as List<dynamic>)
                .whereType<Map<String, dynamic>>()
                .map(MedicalImageType.fromJson)
                .toList();

        _cachedMedicalImageTypes
          ..clear()
          ..addAll(types);

        return right(getCachedMedicalImageTypes());
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles() async {
    try {
      final Response<dynamic> resp = await _apiServices.get(
        endPoint: Urls.patientMedicalRecords,
      );

      final dynamic data = resp.data['data'];
      final dynamic records = data is Map<String, dynamic>
          ? data['records']
          : resp.data['records'];

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          records is List<dynamic>) {
        final List<MedicalFile> files = records
            .whereType<Map<String, dynamic>>()
            .map(MedicalFile.fromAllRecordsJson)
            .toList();

        _replaceCachedFiles(files);
        return right(getCachedMedicalFiles());
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<Failure, List<MedicalFile>>> getUploadedMedicalFiles({
    MedicalFileType? type,
  }) async {
    try {
      final Response<dynamic> resp = await _apiServices.post(
        endPoint: Urls.patientUploadedMedicalRecords,
        data: type == null
            ? <String, dynamic>{}
            : <String, dynamic>{'type': type.apiValue},
      );

      if (resp.statusCode == 200 &&
          resp.data['status'] == true &&
          resp.data['data'] is List<dynamic>) {
        final List<MedicalFile> files = (resp.data['data'] as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .map(MedicalFile.fromUploadJson)
            .toList();

        return right(_sortFiles(files));
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(ErrorHandler.handle(error));
    }
  }

  void _replaceCachedFiles(List<MedicalFile> files) {
    _cachedMedicalFiles
      ..clear()
      ..addAll(_sortFiles(files));
  }

  List<MedicalFile> _sortFiles(List<MedicalFile> files) {
    final List<MedicalFile> sortedFiles = List<MedicalFile>.from(files);
    sortedFiles.sort((MedicalFile first, MedicalFile second) {
      final DateTime firstDate = first.createdAt ?? first.fileDate;
      final DateTime secondDate = second.createdAt ?? second.fileDate;
      return secondDate.compareTo(firstDate);
    });
    return sortedFiles;
  }

  void _upsertCachedFile(MedicalFile file) {
    final List<MedicalFile> updatedFiles = List<MedicalFile>.from(
      _cachedMedicalFiles,
    );
    updatedFiles.removeWhere((MedicalFile item) => item.id == file.id);
    updatedFiles.insert(0, file);
    _replaceCachedFiles(updatedFiles);
  }

  String _buildDownloadFileName(MedicalFile file) {
    final String normalizedTitle = file.title
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final String fileType = file.type == MedicalFileType.radiology
        ? 'radiology'
        : 'lab';
    final String extension = _resolveFileExtension(file);

    return '${normalizedTitle.isEmpty ? fileType : normalizedTitle}_${file.id}$extension';
  }

  String _resolveFileExtension(MedicalFile file) {
    final String? localPath = file.localFilePath;
    if (localPath != null && localPath.contains('.')) {
      return '.${localPath.split('.').last}';
    }

    final String? remotePath = file.remoteFileUrl;
    if (remotePath != null) {
      final Uri? uri = Uri.tryParse(remotePath);
      final String lastSegment = uri?.pathSegments.isNotEmpty == true
          ? uri!.pathSegments.last
          : '';
      if (lastSegment.contains('.')) {
        return '.${lastSegment.split('.').last}';
      }
    }

    final String? apiFilePath = file.filePath;
    if (apiFilePath != null && apiFilePath.contains('.')) {
      return '.${apiFilePath.split('.').last}';
    }

    return '.jpg';
  }
}
