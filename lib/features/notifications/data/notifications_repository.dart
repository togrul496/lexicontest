import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/network/api_client.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(authenticatedDioProvider)),
);

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  return ref.watch(notificationsRepositoryProvider).fetchNotifications();
});

final notificationProvider = FutureProvider.family<NotificationItem, int>((ref, notificationId) async {
  return ref.watch(notificationsRepositoryProvider).fetchNotification(notificationId);
});

class NotificationsRepository {
  NotificationsRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await _dio.get<dynamic>('api/notifications/');
    return unwrapEnvelope(
      response,
      (json) => (json as List<dynamic>)
          .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<NotificationItem> fetchNotification(int id) async {
    final response = await _dio.get<dynamic>('api/notifications/$id');
    return unwrapEnvelope(
      response,
      (json) => NotificationItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> markRead(int id) async {
    await _dio.post<dynamic>('api/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _dio.post<dynamic>('api/notifications/read-all');
  }

  Future<void> toggleLike({required int id, required bool isLiked}) async {
    if (isLiked) {
      await _dio.delete<dynamic>('api/notifications/$id/like');
    } else {
      await _dio.post<dynamic>('api/notifications/$id/like');
    }
  }
}

