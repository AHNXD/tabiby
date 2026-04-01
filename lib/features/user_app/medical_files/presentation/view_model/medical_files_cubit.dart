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
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          submissionStatus: MedicalFileSubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (uploadedFile) async {
        final filesResult = await _medicalFilesRepo.getMedicalFiles();
        filesResult.fold(
          (_) {
            final List<MedicalFile> files = _mergeUploadedFile(
              state.files,
              uploadedFile,
            );
            emit(
              state.copyWith(
                status: MedicalFilesStatus.success,
                files: files,
                submissionStatus: MedicalFileSubmissionStatus.success,
                errorMessage: '',
              ),
            );
          },
          (files) => emit(
            state.copyWith(
              status: MedicalFilesStatus.success,
              files: files,
              submissionStatus: MedicalFileSubmissionStatus.success,
              errorMessage: '',
            ),
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

  List<MedicalFile> _mergeUploadedFile(
    List<MedicalFile> currentFiles,
    MedicalFile uploadedFile,
  ) {
    final List<MedicalFile> updatedFiles = List<MedicalFile>.from(currentFiles);
    updatedFiles.removeWhere((MedicalFile file) => file.id == uploadedFile.id);
    updatedFiles.insert(0, uploadedFile);
    updatedFiles.sort((MedicalFile first, MedicalFile second) {
      final DateTime firstDate = first.createdAt ?? first.fileDate;
      final DateTime secondDate = second.createdAt ?? second.fileDate;
      return secondDate.compareTo(firstDate);
    });
    return updatedFiles;
  }
}
