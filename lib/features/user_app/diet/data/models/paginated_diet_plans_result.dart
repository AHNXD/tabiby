import 'diet_plan_history_item.dart';

class PaginatedDietPlansResult {
  const PaginatedDietPlansResult({required this.items, required this.meta});

  final List<DietPlanHistoryItem> items;
  final DietPlansMeta meta;

  factory PaginatedDietPlansResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = _mapOf(json['data']);
    final rawItems = data['items'] as List<dynamic>? ?? const [];

    return PaginatedDietPlansResult(
      items: rawItems
          .whereType<Map>()
          .map(
            (item) =>
                DietPlanHistoryItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      meta: DietPlansMeta.fromJson(_mapOf(data['meta'])),
    );
  }
}

class DietPlansMeta {
  const DietPlansMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  final int page;
  final int limit;
  final int total;

  factory DietPlansMeta.fromJson(Map<String, dynamic> json) {
    return DietPlansMeta(
      page: _toInt(json['page'], 1),
      limit: _toInt(json['limit'], 20),
      total: _toInt(json['total'], 0),
    );
  }
}

Map<String, dynamic> _mapOf(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

int _toInt(dynamic value, int fallback) {
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
