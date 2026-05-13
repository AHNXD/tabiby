import 'package:equatable/equatable.dart';

const Object _unset = Object();

class DoctorsQueryParams extends Equatable {
  final String? search;
  final String? centerName;
  final int? selectedCenterId;
  final String? selectedCenterName;
  final int? selectedSpecialtyId;
  final String? selectedSpecialtyName;
  final int? experienceYears;
  final int? minExperience;
  final int? maxExperience;

  const DoctorsQueryParams({
    this.search,
    this.centerName,
    this.selectedCenterId,
    this.selectedCenterName,
    this.selectedSpecialtyId,
    this.selectedSpecialtyName,
    this.experienceYears,
    this.minExperience,
    this.maxExperience,
  });

  static const DoctorsQueryParams empty = DoctorsQueryParams();

  String? get normalizedSearch => _normalizeText(search);
  String? get normalizedCenterName => _normalizeText(centerName);
  String? get normalizedSelectedCenterName =>
      _normalizeText(selectedCenterName);
  String? get normalizedSelectedSpecialtyName =>
      _normalizeText(selectedSpecialtyName);

  bool get hasActiveSearch => normalizedSearch != null;
  bool get hasSelectedCenter => selectedCenterId != null;
  bool get hasSelectedSpecialty => selectedSpecialtyId != null;
  bool get hasExperienceFilter =>
      experienceYears != null || minExperience != null || maxExperience != null;
  bool get hasActiveFilters =>
      normalizedCenterName != null ||
      hasSelectedCenter ||
      hasSelectedSpecialty ||
      hasExperienceFilter;

  int get activeFilterCount {
    int count = 0;

    if (normalizedCenterName != null) {
      count++;
    }

    if (hasSelectedCenter) {
      count++;
    }

    if (hasSelectedSpecialty) {
      count++;
    }

    if (experienceYears != null) {
      count++;
    } else if (minExperience != null || maxExperience != null) {
      count++;
    }

    return count;
  }

  Map<String, String> toQueryParameters({required int page}) {
    final Map<String, String> params = <String, String>{'page': '$page'};

    if (normalizedSearch != null) {
      params['search'] = normalizedSearch!;
    }

    if (normalizedCenterName != null) {
      params['center_name'] = normalizedCenterName!;
    }

    if (experienceYears != null) {
      params['experience_years'] = '$experienceYears';
    } else {
      if (minExperience != null) {
        params['min_experience'] = '$minExperience';
      }
      if (maxExperience != null) {
        params['max_experience'] = '$maxExperience';
      }
    }

    return params;
  }

  DoctorsQueryParams copyWith({
    Object? search = _unset,
    Object? centerName = _unset,
    Object? selectedCenterId = _unset,
    Object? selectedCenterName = _unset,
    Object? selectedSpecialtyId = _unset,
    Object? selectedSpecialtyName = _unset,
    Object? experienceYears = _unset,
    Object? minExperience = _unset,
    Object? maxExperience = _unset,
  }) {
    return DoctorsQueryParams(
      search: identical(search, _unset) ? this.search : search as String?,
      centerName: identical(centerName, _unset)
          ? this.centerName
          : centerName as String?,
      selectedCenterId: identical(selectedCenterId, _unset)
          ? this.selectedCenterId
          : selectedCenterId as int?,
      selectedCenterName: identical(selectedCenterName, _unset)
          ? this.selectedCenterName
          : selectedCenterName as String?,
      selectedSpecialtyId: identical(selectedSpecialtyId, _unset)
          ? this.selectedSpecialtyId
          : selectedSpecialtyId as int?,
      selectedSpecialtyName: identical(selectedSpecialtyName, _unset)
          ? this.selectedSpecialtyName
          : selectedSpecialtyName as String?,
      experienceYears: identical(experienceYears, _unset)
          ? this.experienceYears
          : experienceYears as int?,
      minExperience: identical(minExperience, _unset)
          ? this.minExperience
          : minExperience as int?,
      maxExperience: identical(maxExperience, _unset)
          ? this.maxExperience
          : maxExperience as int?,
    );
  }

  DoctorsQueryParams clearFilters() {
    return DoctorsQueryParams(search: search);
  }

  static String? _normalizeText(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  List<Object?> get props => <Object?>[
    normalizedSearch,
    normalizedCenterName,
    selectedCenterId,
    normalizedSelectedCenterName,
    selectedSpecialtyId,
    normalizedSelectedSpecialtyName,
    experienceYears,
    minExperience,
    maxExperience,
  ];
}
