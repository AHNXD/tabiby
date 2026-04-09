import 'dart:io';

import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';

import '../../../Image_diagnosis/data/models/diagnosis_model.dart';

class RadiologyRepo {
  Future<DiagnosisModel> analyzeXRay(File imageFile) async {
    final result = await getit.get<DiagnosisRepository>().analyzeChestXray(
      imageFile.path,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}
