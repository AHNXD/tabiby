part of 'medical_files_cubit.dart';

enum MedicalFilesStatus { initial, loading, success, failure }

enum MedicalFileSubmissionStatus { idle, submitting, success, failure }

class MedicalFilesState extends Equatable {
  const MedicalFilesState({
    this.status = MedicalFilesStatus.initial,
    this.submissionStatus = MedicalFileSubmissionStatus.idle,
    this.files = const <MedicalFile>[],
    this.filter = MedicalFilesFilter.all,
    this.errorMessage = '',
  });

  final MedicalFilesStatus status;
  final MedicalFileSubmissionStatus submissionStatus;
  final List<MedicalFile> files;
  final MedicalFilesFilter filter;
  final String errorMessage;

  List<MedicalFile> get filteredFiles =>
      files.where((MedicalFile file) => file.matchesFilter(filter)).toList();

  MedicalFilesState copyWith({
    MedicalFilesStatus? status,
    MedicalFileSubmissionStatus? submissionStatus,
    List<MedicalFile>? files,
    MedicalFilesFilter? filter,
    String? errorMessage,
  }) {
    return MedicalFilesState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      files: files ?? this.files,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    submissionStatus,
    files,
    filter,
    errorMessage,
  ];
}
