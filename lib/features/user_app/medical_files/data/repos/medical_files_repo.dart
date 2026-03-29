import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/medical_file_model.dart';

abstract class MedicalFilesRepo {
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles();

  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  );

  List<MedicalFile> getCachedMedicalFiles();
}
