import 'api_service.dart';

class MovieApi {
  static Future<Map<String, dynamic>> getHome() {
    return ApiService.get('/movies/home');
  }

  static Future<Map<String, dynamic>> getMovieById(int id) {
    return ApiService.get('/movies/$id');
  }

  static Future<Map<String, dynamic>> getMoviesByCategory(String? category, {int page = 1}) {
    final params = <String, String>{'page': page.toString(), 'limit': '20'};
    if (category != null && category.isNotEmpty) params['category'] = category;
    return ApiService.get('/movies', params: params);
  }

  static Future<Map<String, dynamic>> search(String query, {int page = 1}) {
    return ApiService.get('/movies', params: {
      'search': query,
      'page': page.toString(),
      'limit': '20',
    });
  }

  static Future<Map<String, dynamic>> getFavorites() {
    return ApiService.get('/favorites');
  }

  static Future<Map<String, dynamic>> toggleFavorite(int movieId) {
    return ApiService.post('/favorites/$movieId/toggle', {});
  }

  static Future<Map<String, dynamic>> submitReview(int movieId, int rating, String text) {
    return ApiService.post('/movies/$movieId/reviews', {'rating': rating, 'text': text});
  }

  static Future<void> saveProgress(int movieId, int progressSeconds, int totalSeconds) async {
    try {
      await ApiService.post('/movies/$movieId/progress', {
        'progress_seconds': progressSeconds,
        'total_seconds': totalSeconds,
      });
    } catch (_) {}
  }

  static String fullImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    return '${ApiService.baseUrl.replaceAll('/api', '')}$url';
  }
}
