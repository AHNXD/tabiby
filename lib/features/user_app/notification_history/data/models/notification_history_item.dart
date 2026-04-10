import 'package:equatable/equatable.dart';

class NotificationHistoryItem extends Equatable {
  const NotificationHistoryItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.appointmentId,
    this.readAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final int? appointmentId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  factory NotificationHistoryItem.fromJson(Map<String, dynamic> json) {
    return NotificationHistoryItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      appointmentId: _parseAppointmentId(json['appointment_id']),
      isRead: json['is_read'] == true,
      readAt: _parseDateTime(json['read_at']),
      createdAt:
          _parseDateTime(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static int? _parseAppointmentId(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    final String normalized = value.toString().trim().replaceFirst(' ', 'T');
    return DateTime.tryParse(normalized);
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    body,
    type,
    appointmentId,
    isRead,
    readAt,
    createdAt,
  ];
}
