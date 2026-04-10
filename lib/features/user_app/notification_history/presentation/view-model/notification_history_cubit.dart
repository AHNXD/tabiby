import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/notification_history_item.dart';
import '../../data/repos/notification_history_repo.dart';

part 'notification_history_state.dart';

class NotificationHistoryCubit extends Cubit<NotificationHistoryState> {
  NotificationHistoryCubit(this._notificationHistoryRepo)
    : super(const NotificationHistoryState());

  final NotificationHistoryRepo _notificationHistoryRepo;

  Future<void> loadNotifications({bool force = false}) async {
    if (state.status == NotificationHistoryStatus.loading) {
      return;
    }

    if (!force && state.status == NotificationHistoryStatus.success) {
      return;
    }

    emit(
      state.copyWith(
        status: NotificationHistoryStatus.loading,
        errorMessage: '',
      ),
    );

    final result = await _notificationHistoryRepo.getNotifications();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: NotificationHistoryStatus.success,
          notifications: response.items,
          unreadCount: response.unreadCount,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    NotificationHistoryItem? targetNotification;
    for (final NotificationHistoryItem item in state.notifications) {
      if (item.id == notificationId) {
        targetNotification = item;
        break;
      }
    }

    if (targetNotification == null ||
        targetNotification.isRead ||
        state.processingNotificationId == notificationId) {
      return;
    }

    emit(
      state.copyWith(
        readStatus: NotificationReadStatus.loading,
        processingNotificationId: notificationId,
        actionErrorMessage: '',
      ),
    );

    final result = await _notificationHistoryRepo.markAsRead(notificationId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          readStatus: NotificationReadStatus.failure,
          clearProcessingNotificationId: true,
          actionErrorMessage: failure.message,
        ),
      ),
      (updatedNotification) {
        final List<NotificationHistoryItem> updatedNotifications = state
            .notifications
            .map((NotificationHistoryItem notification) {
              if (notification.id == updatedNotification.id) {
                return updatedNotification;
              }
              return notification;
            })
            .toList();

        emit(
          state.copyWith(
            status: NotificationHistoryStatus.success,
            notifications: updatedNotifications,
            unreadCount: updatedNotifications
                .where((NotificationHistoryItem item) => !item.isRead)
                .length,
            readStatus: NotificationReadStatus.success,
            clearProcessingNotificationId: true,
            actionErrorMessage: '',
          ),
        );
      },
    );
  }

  void clearReadStatus() {
    emit(
      state.copyWith(
        readStatus: NotificationReadStatus.idle,
        clearProcessingNotificationId: true,
        actionErrorMessage: '',
      ),
    );
  }
}
