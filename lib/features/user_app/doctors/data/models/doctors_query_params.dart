import 'package:equatable/equatable.dart';

const Object _unset = Object();

class DoctorsQueryParams extends Equatable {
  final String? search;
  final String? centerName;
  final int? experienceYears;
  final int? minExperience;
  final int? maxExperience;

  const DoctorsQueryParams({
    this.search,
    this.centerName,
    this.experienceYears,
    this.minExperience,
    this.maxExperience,
  });

  static const DoctorsQueryParams empty = DoctorsQueryParams();

  String? get normalizedSearch => _normalizeText(search);
  String? get normalizedCenterName => _normalizeText(centerName);

  bool get hasActiveSearch => normalizedSearch != null;
  bool get hasExperienceFilter =>
      experienceYears != null || minExperience != null || maxExperience != null;
  bool get hasActiveFilters =>
      normalizedCenterName != null || hasExperienceFilter;

  int get activeFilterCount {
    int count = 0;

    if (normalizedCenterName != null) {
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
    Object? experienceYears = _unset,
    Object? minExperience = _unset,
    Object? maxExperience = _unset,
  }) {
    return DoctorsQueryParams(
      search: identical(search, _unset) ? this.search : search as String?,
      centerName: identical(centerName, _unset)
          ? this.centerName
          : centerName as String?,
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
    experienceYears,
    minExperience,
    maxExperience,
  ];
}
