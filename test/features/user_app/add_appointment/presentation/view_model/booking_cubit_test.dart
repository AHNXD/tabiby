import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/centers_appointment_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/days_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/times_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo.dart';
import 'package:tabiby/features/user_app/add_appointment/presentation/view-model/booking_cubit.dart';
import 'package:tabiby/features/user_app/add_appointment/presentation/view-model/booking_state.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

void main() {
  group('BookingCubit', () {
    late _FakeAddAppointmentRepo appointmentRepo;
    late _FakeMedicalFilesRepo medicalFilesRepo;
    late BookingCubit cubit;

    setUp(() {
      appointmentRepo = _FakeAddAppointmentRepo();
      medicalFilesRepo = _FakeMedicalFilesRepo();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('fetchCenters loads doctor centers and medical attachments', () async {
      final centers = <Centers>[Centers(id: 1, name: 'Main Center')];
      appointmentRepo.centersResult = right(centers);
      medicalFilesRepo.medicalFilesResult = right(<MedicalFile>[
        _medicalFile(id: 7, title: 'Chest Xray'),
      ]);
      cubit = _doctorCubit(appointmentRepo, medicalFilesRepo);

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<BookingLoading>(),
          isA<BookingSuccess>()
              .having((state) => state.centers, 'centers', centers)
              .having(
                (state) => state.availableMedicalAttachments.length,
                'availableMedicalAttachments.length',
                1,
              )
              .having(
                (state) => state.departmentType,
                'departmentType',
                BookingDepartmentType.doctor,
              ),
        ]),
      );

      await cubit.fetchCenters();
      await expectation;

      expect(medicalFilesRepo.getMedicalFilesCallCount, 1);
    });

    test('selectCenter loads laboratory days and lab tests', () async {
      final centers = <Centers>[Centers(id: 3, name: 'Lab Center')];
      final days = <Days>[Days(date: '2026-05-18')];
      final labTests = <LabTestOption>[const LabTestOption(id: 9, name: 'CBC')];
      appointmentRepo.centersResult = right(centers);
      appointmentRepo.daysResult = right(days);
      appointmentRepo.labTestsResult = right(labTests);
      cubit = _laboratoryCubit(appointmentRepo, medicalFilesRepo);

      await cubit.fetchCenters();

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<BookingSuccess>()
              .having((state) => state.selectedCenterId, 'selectedCenterId', 3)
              .having((state) => state.isLoadingDays, 'isLoadingDays', true)
              .having((state) => state.days, 'days', isEmpty),
          isA<BookingSuccess>()
              .having((state) => state.selectedCenterId, 'selectedCenterId', 3)
              .having((state) => state.isLoadingDays, 'isLoadingDays', false)
              .having((state) => state.days, 'days', days)
              .having((state) => state.availableLabTests, 'labTests', labTests),
        ]),
      );

      await cubit.selectCenter(3);
      await expectation;

      expect(appointmentRepo.getDaysCallCount, 1);
      expect(appointmentRepo.getLabTestsCallCount, 1);
    });

    test('bookAppointment sends selected laboratory payload', () async {
      final centers = <Centers>[Centers(id: 3, name: 'Lab Center')];
      final days = <Days>[Days(date: '2026-05-18')];
      final times = TimesModel(
        periods: Periods(morning: <TimeSlot>[TimeSlot(time: '09:00')]),
      );
      appointmentRepo.centersResult = right(centers);
      appointmentRepo.daysResult = right(days);
      appointmentRepo.timesResult = right(times);
      appointmentRepo.labTestsResult = right(<LabTestOption>[
        const LabTestOption(id: 9, name: 'CBC'),
      ]);
      cubit = _laboratoryCubit(appointmentRepo, medicalFilesRepo);

      await cubit.fetchCenters();
      await cubit.selectCenter(3);
      await cubit.selectDay('2026-05-18');
      cubit.toggleLabTestSelection(9);
      cubit.selectTime('09:00', 'morning');

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<BookingSuccess>().having(
            (state) => state.isBooking,
            'isBooking',
            true,
          ),
          isA<AppointmentBookedSuccessfully>(),
        ]),
      );

      await cubit.bookAppointment(' fasting ');
      await expectation;

      final request = appointmentRepo.lastBookingRequest;
      expect(request, isNotNull);
      expect(request!.doctorId, '42');
      expect(request.centerId, '3');
      expect(request.type, BookingDepartmentType.laboratory);
      expect(request.labTests, <int>[9]);
      expect(request.toJson(), containsPair('note', 'fasting'));
      expect(request.toJson(), containsPair('lab_tests', <int>[9]));
    });
  });
}

BookingCubit _doctorCubit(
  _FakeAddAppointmentRepo appointmentRepo,
  _FakeMedicalFilesRepo medicalFilesRepo,
) {
  return BookingCubit(
    appointmentRepo,
    medicalFilesRepo,
    42,
    departmentType: BookingDepartmentType.doctor,
  );
}

BookingCubit _laboratoryCubit(
  _FakeAddAppointmentRepo appointmentRepo,
  _FakeMedicalFilesRepo medicalFilesRepo,
) {
  return BookingCubit(
    appointmentRepo,
    medicalFilesRepo,
    42,
    departmentType: BookingDepartmentType.laboratory,
  );
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

class _FakeAddAppointmentRepo implements AddAppoinmentRepo {
  Either<Failure, List<Centers>> centersResult = right(const <Centers>[]);
  Either<Failure, List<Days>> daysResult = right(const <Days>[]);
  Either<Failure, TimesModel> timesResult = right(TimesModel());
  Either<Failure, List<LabTestOption>> labTestsResult = right(
    const <LabTestOption>[],
  );
  Either<Failure, List<MedicalImageTypeOption>> medicalImageTypesResult = right(
    const <MedicalImageTypeOption>[],
  );
  Either<Failure, bool> bookAppointmentResult = right(true);
  AppointmentBookingRequest? lastBookingRequest;
  int getDaysCallCount = 0;
  int getLabTestsCallCount = 0;

  @override
  Future<Either<Failure, bool>> bookAppointment(
    AppointmentBookingRequest request,
  ) async {
    lastBookingRequest = request;
    return bookAppointmentResult;
  }

  @override
  Future<Either<Failure, List<Centers>>> getCenters(int? doctorID) async {
    return centersResult;
  }

  @override
  Future<Either<Failure, List<Days>>> getDays(
    int? doctorID,
    int? centerID,
  ) async {
    getDaysCallCount++;
    return daysResult;
  }

  @override
  Future<Either<Failure, List<LabTestOption>>> getLabTests(int centerId) async {
    getLabTestsCallCount++;
    return labTestsResult;
  }

  @override
  Future<Either<Failure, List<MedicalImageTypeOption>>> getMedicalImageTypes(
    int centerId,
  ) async {
    return medicalImageTypesResult;
  }

  @override
  Future<Either<Failure, TimesModel>> getTimes(
    int? doctorID,
    int? centerID,
    String date,
  ) async {
    return timesResult;
  }
}

class _FakeMedicalFilesRepo implements MedicalFilesRepo {
  Either<Failure, List<MedicalFile>> medicalFilesResult = right(
    const <MedicalFile>[],
  );
  int getMedicalFilesCallCount = 0;

  @override
  Future<Either<Failure, MedicalFile>> addMedicalFile(
    CreateMedicalFileRequest request,
  ) async {
    return right(_medicalFile(id: 1));
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
    getMedicalFilesCallCount++;
    return medicalFilesResult;
  }

  @override
  Future<Either<Failure, List<MedicalImageType>>> getMedicalImageTypes() async {
    return right(const <MedicalImageType>[]);
  }

  @override
  Future<Either<Failure, List<MedicalFile>>> getUploadedMedicalFiles({
    MedicalFileType? type,
  }) async {
    return medicalFilesResult;
  }
}
