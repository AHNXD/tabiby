part of 'notification_history_cubit.dart';

enum NotificationHistoryStatus { initial, loading, success, failure }

enum NotificationReadStatus { idle, loading, success, failure }

class NotificationHistoryState extends Equatable {
  const NotificationHistoryState({
    this.status = NotificationHistoryStatus.initial,
    this.readStatus = NotificationReadStatus.idle,
    this.notifications = const <NotificationHistoryItem>[],
    this.unreadCount = 0,
    this.errorMessage = '',
    this.actionErrorMessage = '',
    this.processingNotificationId,
  });

  final NotificationHistoryStatus status;
  final NotificationReadStatus readStatus;
  final List<NotificationHistoryItem> notifications;
  final int unreadCount;
  final String errorMessage;
  final String actionErrorMessage;
  final String? processingNotificationId;

  bool get isInitialLoading =>
      status == NotificationHistoryStatus.loading && notifications.isEmpty;

  NotificationHistoryState copyWith({
    NotificationHistoryStatus? status,
    NotificationReadStatus? readStatus,
    List<NotificationHistoryItem>? notifications,
    int? unreadCount,
    String? errorMessage,
    String? actionErrorMessage,
    String? processingNotificationId,
    bool clearProcessingNotificationId = false,
  }) {
    return NotificationHistoryState(
      status: status ?? this.status,
      readStatus: readStatus ?? this.readStatus,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      processingNotificationId: clearProcessingNotificationId
          ? null
          : processingNotificationId ?? this.processingNotificationId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    readStatus,
    notifications,
    unreadCount,
    errorMessage,
    actionErrorMessage,
    processingNotificationId,
  ];
}
