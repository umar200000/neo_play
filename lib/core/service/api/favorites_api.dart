import 'api_service.dart';

class FavoritesApi {
  static Future<Map<String, dynamic>> getFavorites() {
    return ApiService.get('/favorites');
  }

  static Future<Map<String, dynamic>> toggleFavorite(int movieId) {
    return ApiService.post('/favorites/$movieId/toggle', {});
  }
}
