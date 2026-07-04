import 'api_service.dart';

class DevicesApi {
  static Future<Map<String, dynamic>> getDevices() {
    return ApiService.get('/devices');
  }

  static Future<void> logoutDevice(int sessionId) async {
    await ApiService.delete('/devices/$sessionId');
  }

  static Future<void> logoutAllDevices() async {
    await ApiService.delete('/devices');
  }
}
