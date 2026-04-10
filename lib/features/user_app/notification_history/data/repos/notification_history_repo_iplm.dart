import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/notification_history_item.dart';
import '../models/notification_history_response.dart';
import 'notification_history_repo.dart';

class NotificationHistoryRepoIplm implements NotificationHistoryRepo {
  NotificationHistoryRepoIplm(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<Either<Failure, NotificationHistoryResponse>>
  getNotifications() async {
    try {
      final response = await _apiServices.get(endPoint: Urls.notifications);
      final Map<String, dynamic>? body = _normalizeMap(response.data);

      if (response.statusCode == 200 && _isSuccessful(body)) {
        return right(NotificationHistoryResponse.fromJson(body!));
      }

      return left(
        ServerFailure(_extractMessage(body) ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(_mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, NotificationHistoryItem>> markAsRead(
    String notificationId,
  ) async {
    try {
      final response = await _apiServices.post(
        endPoint: Urls.markNotificationAsRead(notificationId),
        data: const <String, dynamic>{},
      );
      final Map<String, dynamic>? body = _normalizeMap(response.data);
      final Map<String, dynamic>? notificationJson = _extractNotification(body);

      if (response.statusCode == 200 &&
          _isSuccessful(body) &&
          notificationJson != null) {
        return right(NotificationHistoryItem.fromJson(notificationJson));
      }

      return left(
        ServerFailure(_extractMessage(body) ?? ErrorHandler.defaultMessage()),
      );
    } catch (error) {
      return left(_mapFailure(error));
    }
  }

  Failure _mapFailure(dynamic error) {
    if (error is DioException) {
      final Map<String, dynamic>? body = _normalizeMap(error.response?.data);
      final String? message = _extractMessage(body);
      if (message != null && message.isNotEmpty) {
        return ServerFailure(message);
      }
    }

    return ErrorHandler.handle(error);
  }

  Map<String, dynamic>? _normalizeMap(dynamic source) {
    if (source is Map<String, dynamic>) {
      return source;
    }

    if (source is Map) {
      return Map<String, dynamic>.from(source);
    }

    return null;
  }

  bool _isSuccessful(Map<String, dynamic>? body) {
    if (body == null) {
      return false;
    }

    if (body['status'] == null) {
      return true;
    }

    return body['status'] == true;
  }

  String? _extractMessage(Map<String, dynamic>? body) {
    final dynamic message = body?['message'];
    if (message == null) {
      return null;
    }

    return message.toString();
  }

  Map<String, dynamic>? _extractNotification(Map<String, dynamic>? body) {
    final dynamic notification = body?['data']?['notification'];
    if (notification is Map<String, dynamic>) {
      return notification;
    }

    if (notification is Map) {
      return Map<String, dynamic>.from(notification);
    }

    return null;
  }
}
