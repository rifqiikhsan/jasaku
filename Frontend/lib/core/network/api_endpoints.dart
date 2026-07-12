class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://jasaku-api.rifqiikhsan.my.id';

  // ── Auth ────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String profile = '/auth/profile';

  // ── Category ────────────────────────────────────────────────
  static const String categories = '/categories';
  static String categoryDetail(String id) => '/categories/$id';

  // ── Jasa ────────────────────────────────────────────────
  static const String services = '/services';
  static String serviceDetail(String id) => '/services/$id';

  // ── Order ────────────────────────────────────────────────
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';

  // ── Chat ────────────────────────────────────────────────
  static const String conversations = '/conversations';
  static String messages(String roomId) => '/conversations/$roomId/messages';
}
