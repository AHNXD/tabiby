import 'package:equatable/equatable.dart';

const Object _unset = Object();

class CentersQueryParams extends Equatable {
  final String? search;

  const CentersQueryParams({this.search});

  static const CentersQueryParams empty = CentersQueryParams();

  String? get normalizedSearch {
    final String trimmed = search?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  bool get hasActiveSearch => normalizedSearch != null;

  Map<String, String> toQueryParameters({required int page}) {
    final Map<String, String> params = <String, String>{'page': '$page'};

    if (normalizedSearch != null) {
      params['search'] = normalizedSearch!;
    }

    return params;
  }

  CentersQueryParams copyWith({Object? search = _unset}) {
    return CentersQueryParams(
      search: identical(search, _unset) ? this.search : search as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[normalizedSearch];
}
