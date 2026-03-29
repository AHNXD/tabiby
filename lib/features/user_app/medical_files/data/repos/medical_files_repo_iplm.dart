import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/medical_file_model.dart';
import 'medical_files_repo.dart';

class MedicalFilesRepoIplm implements MedicalFilesRepo {
  final List<MedicalFile> _cachedMedicalFiles = <MedicalFile>[];
  int _nextId = 1;

  @override
  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  ) async {
    final MedicalFile file = MedicalFile(
      id: _nextId++,
      title: request.title.trim(),
      type: request.type,
      fileDate: request.fileDate,
      localFilePath: request.imageFile.path,
      createdAt: DateTime.now(),
    );

    _cachedMedicalFiles.insert(0, file);

    return right(file);
  }

  @override
  List<MedicalFile> getCachedMedicalFiles() {
    return List<MedicalFile>.unmodifiable(_cachedMedicalFiles);
  }

  @override
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles() async {
    return right(getCachedMedicalFiles());
  }
}
