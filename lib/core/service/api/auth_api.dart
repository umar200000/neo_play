import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class AuthApi {
  static Future<Map<String, dynamic>> sendOtp(String phone) {
    return ApiService.post('/auth/send-otp', {'phone': phone});
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String code) {
    return ApiService.post('/auth/verify-otp', {'phone': phone, 'code': code});
  }

  static Future<Map<String, dynamic>> register(String firstName, String lastName) {
    return ApiService.post('/auth/register', {'first_name': firstName, 'last_name': lastName});
  }

  static Future<Map<String, dynamic>> getMe() {
    return ApiService.get('/auth/me');
  }

  static Future<Map<String, dynamic>> updateProfile({String? firstName, String? lastName, String? language}) {
    return ApiService.put('/auth/profile', {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (language != null) 'language': language,
    });
  }

  static Future<void> setToken(String token) async {
    await ApiService.setToken(token);
  }

  static Future<Map<String, dynamic>> uploadAvatar(File imageFile) async {
    final token = await ApiService.getToken();
    final uri = Uri.parse('${ApiService.baseUrl}/auth/avatar');
    final request = http.MultipartRequest('PUT', uri);
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    if (streamed.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Xatolik');
    }
    return data;
  }

  static Future<void> logout() async {
    try { await ApiService.post('/auth/logout', {}); } catch (_) {}
    await ApiService.clearToken();
  }
}
