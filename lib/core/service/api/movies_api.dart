import 'api_service.dart';

class MoviesApi {
  static Future<Map<String, dynamic>> getHome({String? userId}) {
    return ApiService.get('/movies/home');
  }

  static Future<Map<String, dynamic>> getMovies({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
    String sort = 'created_at',
  }) {
    return ApiService.get('/movies', params: {
      if (category != null && category != 'all') 'category': category,
      if (search != null) 'search': search,
      'page': '$page',
      'limit': '$limit',
      'sort': sort,
    });
  }

  static Future<Map<String, dynamic>> getMovie(int id) {
    return ApiService.get('/movies/$id');
  }

  static Future<Map<String, dynamic>> getReviews(int movieId, {int page = 1}) {
    return ApiService.get('/movies/$movieId/reviews', params: {'page': '$page'});
  }

  static Future<Map<String, dynamic>> addReview(int movieId, int rating, String text) {
    return ApiService.post('/movies/$movieId/reviews', {'rating': rating, 'text': text});
  }

  static Future<Map<String, dynamic>> saveProgress(int movieId, int progressSeconds, int totalSeconds, {int? episodeId}) {
    return ApiService.post('/movies/$movieId/progress', {
      'progress_seconds': progressSeconds,
      'total_seconds': totalSeconds,
      if (episodeId != null) 'episode_id': episodeId,
    });
  }

  static Future<Map<String, dynamic>> search(String query, {String? category}) {
    return ApiService.get('/search', params: {'q': query, if (category != null) 'category': category});
  }

  static Future<Map<String, dynamic>> getCategories() {
    return ApiService.get('/categories');
  }
}
