import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_request_model.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/symptom_model.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/xray_diagnosis_result_model.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

void main() {
  group('DiagnosisCubit', () {
    late _FakeDiagnosisRepository diagnosisRepo;
    late _FakeMedicalFilesRepo medicalFilesRepo;
    late DiagnosisCubit cubit;

    setUp(() {
      diagnosisRepo = _FakeDiagnosisRepository();
      medicalFilesRepo = _FakeMedicalFilesRepo();
      cubit = DiagnosisCubit(diagnosisRepo, medicalFilesRepo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('fetchSymptomsForSelectedPart emits loading then symptoms', () async {
      final symptoms = <Symptom>[_symptom(id: 'cough')];
      diagnosisRepo.symptomsResult = right(symptoms);
      cubit.selectBodyPart(partKey: 'chest', partLabel: 'Chest');

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<DiagnosisState>().having(
            (state) => state.symptomsState,
            'symptomsState',
            ViewState.loading,
          ),
          isA<DiagnosisState>()
              .having(
                (state) => state.symptomsState,
                'symptomsState',
                ViewState.success,
              )
              .having((state) => state.symptoms, 'symptoms', symptoms)
              .having((state) => state.errorMessage, 'errorMessage', isEmpty),
        ]),
      );

      await cubit.fetchSymptomsForSelectedPart();
      await expectation;

      expect(diagnosisRepo.lastBodyPart, 'Chest');
    });

    test('submitDiagnosis requires at least one selected symptom', () async {
      await cubit.submitDiagnosis();

      expect(cubit.state.resultState, ViewState.error);
      expect(cubit.state.errorMessage, 'no_symptom_selected');
      expect(diagnosisRepo.postDiagnosisCallCount, 0);
    });

    test('submitDiagnosis posts selected symptom answers', () async {
      diagnosisRepo.symptomsResult = right(<Symptom>[_symptom(id: 'pain')]);
      diagnosisRepo.diagnosisResult = right(_diagnosisResult());
      cubit.selectBodyPart(partKey: 'head', partLabel: 'Head');
      await cubit.fetchSymptomsForSelectedPart();
      cubit.toggleSymptomSelection(0, true);
      cubit.answerQuestion(0, 0, 'severe');

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<DiagnosisState>().having(
            (state) => state.resultState,
            'resultState',
            ViewState.loading,
          ),
          isA<DiagnosisState>()
              .having(
                (state) => state.resultState,
                'resultState',
                ViewState.success,
              )
              .having(
                (state) => state.diagnosisResult?.conditionName,
                'conditionName',
                'Migraine',
              ),
        ]),
      );

      await cubit.submitDiagnosis();
      await expectation;

      expect(diagnosisRepo.lastDiagnosisRequest, isNotNull);
      expect(diagnosisRepo.lastDiagnosisRequest!.toJson(), {
        'selected_symptoms': <Map<String, dynamic>>[
          {
            'id': 'pain',
            'label_ar': 'ألم',
            'answers': <String, dynamic>{'severity': 'severe'},
          },
        ],
      });
    });

    test('analyzeSelectedXray requires a selected image first', () async {
      await cubit.analyzeSelectedXray();

      expect(cubit.state.xrayState, ViewState.error);
      expect(cubit.state.errorMessage, 'xray_select_image_first');
    });
  });
}

Symptom _symptom({required String id}) {
  return Symptom(
    id: id,
    labelAr: 'ألم',
    labelEn: 'Pain',
    questions: const <SymptomQuestion>[
      SymptomQuestion(id: 'severity', labelAr: 'الشدة', type: 'dropdown'),
    ],
  );
}

DiagnosisResult _diagnosisResult() {
  return const DiagnosisResult(
    urgency: 'Medium',
    isEmergency: false,
    conditionName: 'Migraine',
    confidence: '82%',
    specialist: 'Neurologist',
    reasoning: 'Symptoms match migraine pattern.',
    adviceSteps: <String>['Rest', 'Hydrate'],
  );
}

class _FakeDiagnosisRepository implements DiagnosisRepository {
  Either<Failure, List<Symptom>> symptomsResult = right(const <Symptom>[]);
  Either<Failure, DiagnosisResult> diagnosisResult = right(_diagnosisResult());
  Either<Failure, XrayDiagnosisResult> xrayResult = right(
    const XrayDiagnosisResult(
      aiDiagnosis: 'Normal',
      findings: <String, double>{'Normal': 0.9},
      topDisease: 'Normal',
      topProbability: 0.9,
    ),
  );
  String? lastBodyPart;
  DiagnosisRequest? lastDiagnosisRequest;
  int postDiagnosisCallCount = 0;

  @override
  Future<Either<Failure, XrayDiagnosisResult>> analyzeChestXray(
    String imagePath,
  ) async {
    return xrayResult;
  }

  @override
  Future<Either<Failure, List<Symptom>>> getSymptoms(String bodyPart) async {
    lastBodyPart = bodyPart;
    return symptomsResult;
  }

  @override
  Future<Either<Failure, DiagnosisResult>> postDiagnosis(
    DiagnosisRequest request,
  ) async {
    postDiagnosisCallCount++;
    lastDiagnosisRequest = request;
    return diagnosisResult;
  }
}

class _FakeMedicalFilesRepo implements MedicalFilesRepo {
  @override
  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  ) async {
    return left(const ServerFailure('not_implemented'));
  }

  @override
  Future<Either<Failure, String>> downloadMedicalFileToTemp(
    MedicalFile file,
  ) async {
    return right('');
  }

  @override
  List<MedicalFile> getCachedMedicalFiles() => const <MedicalFile>[];

  @override
  List<MedicalImageType> getCachedMedicalImageTypes() =>
      const <MedicalImageType>[];

  @override
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles() async {
    return right(const <MedicalFile>[]);
  }

  @override
  Future<Either<Failure, List<MedicalImageType>>> getMedicalImageTypes() async {
    return right(const <MedicalImageType>[]);
  }

  @override
  Future<Either<Failure, List<MedicalFile>>> getUploadedMedicalFiles({
    MedicalFileType? type,
  }) async {
    return right(const <MedicalFile>[]);
  }
}
