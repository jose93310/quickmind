class ApiConstants {
  // ===== CONFIGURACIÓN DE ENTORNO =====
  // Cambia esta URL según el entorno:
  // - Emulador Android: http://10.0.2.2:5256
  // - Dispositivo físico (misma red): http://TU_IP_LOCAL:5256
  // - Producción (Render): https://quickmind-api.onrender.com
  
  static const String serverUrl = 'https://quickmind-api.onrender.com';
  static const String baseUrl = '$serverUrl/api';
  
  static const Duration timeout = Duration(seconds: 30);
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String guestLogin = '/auth/guest';
  static const String profile = '/auth/profile';
  
  static const String games = '/games';
  static const String joinGame = '/games/join';
  static const String categories = '/games/categories';
  static const String publicGames = '/games/public';
  
  static String gameById(String id) => '/games/$id';
  static String gameByCode(String code) => '/games/code/$code';
  static String startGame(String id) => '/games/$id/start';
  static String stopRound(String id) => '/games/$id/stop';
  static const String submitAnswer = '/games/answers';
  static const String vote = '/games/vote';

  // Friends endpoints
  static const String friends = '/friends';
  static const String friendRequest = '/friends/request';
  static const String respondFriendRequest = '/friends/respond';
  static String friendsList(String userId) => '/friends?userId=$userId';
  static String friendRequests(String userId) => '/friends/requests?userId=$userId';
  static String searchUsers(String userId, String query) => '/friends/search?userId=$userId&query=$query';
  static String removeFriend(String userId, String friendId) => '/friends/$friendId?userId=$userId';

  // Chat endpoints
  static const String chatGame = '/chat/game';
  static const String chatDirect = '/chat/direct';
  static const String chatReaction = '/chat/reaction';
  static String chatGameMessages(String gameId) => '/chat/game/$gameId';
  static String chatConversation(String userId1, String userId2) => '/chat/direct?userId1=$userId1&userId2=$userId2';
  static String chatUnread(String userId) => '/chat/unread/$userId';
  static String chatRead(String messageId) => '/chat/read/$messageId';

  // Upload endpoints
  static const String uploadMedia = '/upload/media';
}
