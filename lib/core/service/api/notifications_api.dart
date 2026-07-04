import 'api_service.dart';

class NotificationsApi {
  static Future<Map<String, dynamic>> getNotifications({int page = 1}) {
    return ApiService.get('/notifications', params: {'page': '$page'});
  }

  static Future<void> markRead(int notifId) async {
    await ApiService.post('/notifications/$notifId/read', {});
  }

  static Future<void> markAllRead() async {
    await ApiService.post('/notifications/read-all', {});
  }
}
