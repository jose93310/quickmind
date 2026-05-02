class ApiConstants {
  // Para desarrollo local (emulador Android usa 10.0.2.2, iOS usa localhost)
  static const String baseUrl = 'http://localhost:5256/api';
  
  // Para dispositivo físico, usa tu IP local:
  // static const String baseUrl = 'http://192.168.1.100:5256/api';
  
  // Para producción (cuando deployes el API):
  // static const String baseUrl = 'https://tu-api.com/api';

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
