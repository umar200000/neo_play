import 'api_service.dart';

class SubscriptionsApi {
  static Future<Map<String, dynamic>> getPlans() {
    return ApiService.get('/subscriptions/plans');
  }

  static Future<Map<String, dynamic>> getMySubscriptions() {
    return ApiService.get('/subscriptions/my');
  }

  static Future<Map<String, dynamic>> buySubscription(int planId, String paymentMethod) {
    return ApiService.post('/subscriptions/buy', {'plan_id': planId, 'payment_method': paymentMethod});
  }

  static Future<Map<String, dynamic>> topUpBalance(int amount, String method) {
    return ApiService.post('/subscriptions/topup', {'amount': amount, 'method': method});
  }

  static Future<Map<String, dynamic>> getPaymentHistory() {
    return ApiService.get('/subscriptions/payment-history');
  }
}
