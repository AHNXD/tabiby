import 'notification_history_item.dart';

class NotificationHistoryResponse {
  const NotificationHistoryResponse({
    required this.items,
    required this.unreadCount,
  });

  final List<NotificationHistoryItem> items;
  final int unreadCount;

  factory NotificationHistoryResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : <String, dynamic>{};

    final List<dynamic> rawItems = data['items'] is List
        ? data['items'] as List<dynamic>
        : <dynamic>[];

    return NotificationHistoryResponse(
      items: rawItems
          .whereType<Map>()
          .map(
            (Map item) => NotificationHistoryItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      unreadCount: _parseUnreadCount(data['unread_count']),
    );
  }

  static int _parseUnreadCount(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
