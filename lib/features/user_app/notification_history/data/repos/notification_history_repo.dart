import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failuer.dart';
import '../models/notification_history_item.dart';
import '../models/notification_history_response.dart';

abstract class NotificationHistoryRepo {
  Future<Either<Failure, NotificationHistoryResponse>> getNotifications();

  Future<Either<Failure, NotificationHistoryItem>> markAsRead(
    String notificationId,
  );
}
