import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/medical_file_model.dart';

abstract class MedicalFilesRepo {
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles();

  Future<Either<Failure, List<MedicalFile>>> getUploadedMedicalFiles({
    MedicalFileType? type,
  });

  Future<Either<Failure, List<MedicalImageType>>> getMedicalImageTypes();

  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  );

  Future<Either<Failure, String>> downloadMedicalFileToTemp(MedicalFile file);

  List<MedicalFile> getCachedMedicalFiles();

  List<MedicalImageType> getCachedMedicalImageTypes();
}
