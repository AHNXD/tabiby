import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view_model/medical_files_cubit.dart';

void main() {
  group('MedicalFilesCubit', () {
    late _FakeMedicalFilesRepo repo;
    late MedicalFilesCubit cubit;

    setUp(() {
      repo = _FakeMedicalFilesRepo();
      cubit = MedicalFilesCubit(repo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loadMedicalFiles emits loading then success with files', () async {
      final files = <MedicalFile>[_medicalFile(id: 1)];
      repo.medicalFilesResult = right(files);

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<MedicalFilesState>()
              .having(
                (state) => state.status,
                'status',
                MedicalFilesStatus.loading,
              )
              .having((state) => state.errorMessage, 'errorMessage', isEmpty),
          isA<MedicalFilesState>()
              .having(
                (state) => state.status,
                'status',
                MedicalFilesStatus.success,
              )
              .having((state) => state.files, 'files', files)
              .having((state) => state.errorMessage, 'errorMessage', isEmpty),
        ]),
      );

      await cubit.loadMedicalFiles();
      await expectation;
    });

    test(
      'loadMedicalFiles emits failure message when repository fails',
      () async {
        repo.medicalFilesResult = left(const ServerFailure('server_error'));

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(<Matcher>[
            isA<MedicalFilesState>().having(
              (state) => state.status,
              'status',
              MedicalFilesStatus.loading,
            ),
            isA<MedicalFilesState>()
                .having(
                  (state) => state.status,
                  'status',
                  MedicalFilesStatus.failure,
                )
                .having(
                  (state) => state.errorMessage,
                  'errorMessage',
                  'server_error',
                )
                .having((state) => state.files, 'files', isEmpty),
          ]),
        );

        await cubit.loadMedicalFiles();
        await expectation;
      },
    );

    test(
      'changeFilter updates filteredFiles without changing loaded files',
      () async {
        final radiologyFile = _medicalFile(
          id: 1,
          type: MedicalFileType.radiology,
        );
        final labFile = _medicalFile(id: 2, type: MedicalFileType.lab);
        repo.medicalFilesResult = right(<MedicalFile>[radiologyFile, labFile]);

        await cubit.loadMedicalFiles();
        cubit.changeFilter(MedicalFilesFilter.lab);

        expect(cubit.state.files, <MedicalFile>[radiologyFile, labFile]);
        expect(cubit.state.filter, MedicalFilesFilter.lab);
        expect(cubit.state.filteredFiles, <MedicalFile>[labFile]);
      },
    );

    test(
      'addMedicalFile emits submitting then success and refreshes list',
      () async {
        final uploadedFile = _medicalFile(id: 3, title: 'Uploaded');
        final refreshedFiles = <MedicalFile>[uploadedFile, _medicalFile(id: 1)];
        repo.addMedicalFileResult = right(uploadedFile);
        repo.medicalFilesResult = right(refreshedFiles);

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(<Matcher>[
            isA<MedicalFilesState>().having(
              (state) => state.submissionStatus,
              'submissionStatus',
              MedicalFileSubmissionStatus.submitting,
            ),
            isA<MedicalFilesState>()
                .having(
                  (state) => state.submissionStatus,
                  'submissionStatus',
                  MedicalFileSubmissionStatus.success,
                )
                .having(
                  (state) => state.status,
                  'status',
                  MedicalFilesStatus.success,
                )
                .having((state) => state.files, 'files', refreshedFiles),
          ]),
        );

        await cubit.addMedicalFile(
          CreateMedicalFileRequest(
            title: 'Uploaded',
            type: MedicalFileType.radiology,
            fileDate: DateTime(2026),
            file: File('test/fixtures/upload.png'),
          ),
        );
        await expectation;

        expect(repo.addMedicalFileCallCount, 1);
        expect(repo.getMedicalFilesCallCount, 1);
      },
    );
  });
}

MedicalFile _medicalFile({
  required int id,
  String? title,
  MedicalFileType type = MedicalFileType.radiology,
}) {
  return MedicalFile(
    id: id,
    title: title ?? 'Medical File $id',
    type: type,
    fileDate: DateTime(2026, 1, id),
  );
}

class _FakeMedicalFilesRepo implements MedicalFilesRepo {
  Either<Failure, List<MedicalFile>> medicalFilesResult = right(
    const <MedicalFile>[],
  );
  Either<Failure, MedicalFile> addMedicalFileResult = right(
    _medicalFile(id: 1),
  );
  int getMedicalFilesCallCount = 0;
  int addMedicalFileCallCount = 0;

  @override
  Future<Either<Failure, List<MedicalFile>>> getMedicalFiles() async {
    getMedicalFilesCallCount++;
    return medicalFilesResult;
  }

  @override
  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  ) async {
    addMedicalFileCallCount++;
    return addMedicalFileResult;
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
  Future<Either<Failure, List<MedicalFile>>> getUploadedMedicalFiles({
    MedicalFileType? type,
  }) async {
    return medicalFilesResult;
  }

  @override
  Future<Either<Failure, List<MedicalImageType>>> getMedicalImageTypes() async {
    return right(const <MedicalImageType>[]);
  }
}
