class ApiConstants {
  // Base URL sin /api (para SignalR)
  static const String serverUrl = 'http://localhost:5256';
  
  // Para desarrollo local (emulador Android usa 10.0.2.2, iOS usa localhost)
  static const String baseUrl = '$serverUrl/api';
  
  // Para dispositivo físico, usa tu IP local:
  // static const String serverUrl = 'http://192.168.1.100:5256';
  // static const String baseUrl = '$serverUrl/api';
  
  // Para producción (cuando deployes el API):
  // static const String serverUrl = 'https://tu-api.com';
  // static const String baseUrl = '$serverUrl/api';

  static const Duration timeout = Duration(seconds: 30);
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String guestLogin = '/auth/guest';
  static const String profile = '/auth/profile';
  
  static const String games = '/games';
  static const String joinGame = '/games/join';
  static const String categories = '/games/categories';
  
  static String gameById(String id) => '/games/$id';
  static String gameByCode(String code) => '/games/code/$code';
  static String startGame(String id) => '/games/$id/start';
  static String stopRound(String id) => '/games/$id/stop';
  static const String submitAnswer = '/games/answers';
  static const String vote = '/games/vote';
}
