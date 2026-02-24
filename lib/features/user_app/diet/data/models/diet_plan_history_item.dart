import 'diet_plan_response.dart';
import 'diet_request_data.dart';

class DietPlanHistoryItem {
  const DietPlanHistoryItem({
    required this.id,
    required this.createdAt,
    required this.request,
    required this.plan,
  });

  final String id;
  final DateTime createdAt;
  final DietRequestData request;
  final DietPlanResponse plan;

  factory DietPlanHistoryItem.fromJson(Map<String, dynamic> json) {
    return DietPlanHistoryItem(
      id: (json['id'] ?? '').toString(),
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      request: DietRequestData.fromJson(
        json['request'] as Map<String, dynamic>? ?? const {},
      ),
      plan: DietPlanResponse.fromJson(
        json['plan'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'request': request.toJson(),
      'plan': plan.toJson(),
    };
  }
}
