import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

part 'medical_files_state.dart';

class MedicalFilesCubit extends Cubit<MedicalFilesState> {
  MedicalFilesCubit(this._medicalFilesRepo) : super(const MedicalFilesState());

  final MedicalFilesRepo _medicalFilesRepo;

  Future<void> loadMedicalFiles() async {
    emit(state.copyWith(status: MedicalFilesStatus.loading, errorMessage: ''));

    final result = await _medicalFilesRepo.getMedicalFiles();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MedicalFilesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (files) => emit(
        state.copyWith(
          status: MedicalFilesStatus.success,
          files: files,
          errorMessage: '',
        ),
      ),
    );
  }

  void changeFilter(MedicalFilesFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> addMedicalFile(CreateMedicalFileRequest request) async {
    emit(
      state.copyWith(
        submissionStatus: MedicalFileSubmissionStatus.submitting,
        errorMessage: '',
      ),
    );

    final result = await _medicalFilesRepo.addMedicalFile(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submissionStatus: MedicalFileSubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final List<MedicalFile> files = _medicalFilesRepo
            .getCachedMedicalFiles();
        emit(
          state.copyWith(
            status: MedicalFilesStatus.success,
            files: files,
            submissionStatus: MedicalFileSubmissionStatus.success,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void clearSubmissionStatus() {
    emit(
      state.copyWith(
        submissionStatus: MedicalFileSubmissionStatus.idle,
        errorMessage: '',
      ),
    );
  }
}
