import 'dart:async';
import '../api/game_api.dart';
import '../api/friend_api.dart';
import '../api/chat_api.dart';
import '../models/game_models.dart';
import 'game_hub_service.dart';

/// Servicio principal que combina API REST + SignalR para el juego
class GameService {
  final GameApi _gameApi;
  final FriendApi _friendApi;
  final ChatApi _chatApi;
  final GameHubService _hubService;
  
  // Streams para el UI
  Stream<GameEvent> get gameEvents => _hubService.gameEvents;
  Stream<FriendEvent> get friendEvents => _hubService.friendEvents;
  Stream<GameInvite> get gameInvites => _hubService.gameInvites;
  Stream<ChatEvent> get chatEvents => _hubService.chatEvents;
  bool get isHubConnected => _hubService.isConnected;

  GameService({
    required GameApi gameApi,
    required FriendApi friendApi,
    required ChatApi chatApi,
    required GameHubService hubService,
  })  : _gameApi = gameApi,
        _friendApi = friendApi,
        _chatApi = chatApi,
        _hubService = hubService;

  /// Conectar al hub de SignalR
  Future<void> connect() async {
    await _hubService.connect();
  }

  /// Desconectar del hub
  Future<void> disconnect() async {
    await _hubService.disconnect();
  }

  // ===== API REST Calls =====

  Future<Game> createGame({
    required String hostId,
    required int maxPlayers,
    required int totalRounds,
    required int timePerRound,
    required LetterMode letterMode,
    required ValidationType validationType,
    required List<int> categoryIds,
    bool isPublic = false,
    String? gameName,
  }) async {
    return _gameApi.createGame(
      hostId: hostId,
      maxPlayers: maxPlayers,
      totalRounds: totalRounds,
      timePerRound: timePerRound,
      letterMode: letterMode.index,
      validationType: validationType.index,
      categoryIds: categoryIds,
      isPublic: isPublic,
      gameName: gameName,
    );
  }

  Future<Game> getGame(String gameId) async {
    return _gameApi.getGame(gameId);
  }

  Future<Game> getGameByCode(String code) async {
    return _gameApi.getGameByCode(code);
  }

  Future<Game> joinGame(String gameCode, String userId) async {
    return _gameApi.joinGame(gameCode, userId);
  }

  Future<void> startGame(String gameId, String hostId) async {
    await _gameApi.startGame(gameId, hostId);
  }

  Future<void> stopRound(String gameId, String playerId) async {
    // Notificar a otros jugadores vía SignalR
    await _hubService.stopRound(gameId);
    // Llamar al API
    await _gameApi.stopRound(gameId, playerId);
  }

  Future<void> submitAnswer({
    required String roundId,
    required String playerId,
    required String category,
    required String text,
  }) async {
    await _gameApi.submitAnswer(
      roundId: roundId,
      playerId: playerId,
      category: category,
      text: text,
    );
  }

  Future<void> vote({
    required String answerId,
    required bool isValid,
    required String voterId,
  }) async {
    await _gameApi.vote(
      answerId: answerId,
      isValid: isValid,
      voterId: voterId,
    );
  }

  Future<List<Category>> getCategories({int? ageGroup}) async {
    return _gameApi.getCategories(ageGroup: ageGroup);
  }

  Future<List<PublicGame>> getPublicGames() async {
    return _gameApi.getPublicGames();
  }

  Future<Game> updateGameSettings({
    required String gameId,
    required String hostId,
    required int maxPlayers,
    required int totalRounds,
    required int timePerRound,
    bool isPublic = false,
    String? gameName,
    DateTime? scheduledStart,
  }) async {
    return _gameApi.updateGameSettings(
      gameId: gameId,
      hostId: hostId,
      maxPlayers: maxPlayers,
      totalRounds: totalRounds,
      timePerRound: timePerRound,
      isPublic: isPublic,
      gameName: gameName,
      scheduledStart: scheduledStart,
    );
  }

  // ===== SignalR Calls =====

  Future<void> joinGameHub(String gameCode, String playerId, String nickname) async {
    await _hubService.joinGame(gameCode, playerId, nickname);
  }

  Future<void> leaveGameHub(String gameCode, String playerId) async {
    await _hubService.leaveGame(gameCode, playerId);
  }

  // ===== Friends API Calls =====

  Future<void> sendFriendRequest(String senderId, String receiverNickname) async {
    await _friendApi.sendFriendRequest(senderId, receiverNickname);
  }

  Future<void> respondToFriendRequest(String requestId, String userId, bool accept) async {
    await _friendApi.respondToRequest(requestId, userId, accept);
  }

  Future<List<FriendRequest>> getPendingRequests(String userId) async {
    return _friendApi.getPendingRequests(userId);
  }

  Future<List<Friend>> getFriends(String userId) async {
    return _friendApi.getFriends(userId);
  }

  Future<void> removeFriend(String userId, String friendId) async {
    await _friendApi.removeFriend(userId, friendId);
  }

  Future<List<UserSearchResult>> searchUsers(String userId, String query) async {
    return _friendApi.searchUsers(userId, query);
  }

  Future<void> joinUserHub(String userId) async {
    await _hubService.joinUserGroup(userId);
  }

  Future<void> sendGameInvite(String gameId, String gameCode, String hostNickname, String invitedUserId) async {
    await _hubService.sendGameInvite(gameId, gameCode, hostNickname, invitedUserId);
  }

  // ===== Chat API Calls =====

  Future<List<GameMessage>> getGameMessages(String gameId) async {
    return _chatApi.getGameMessages(gameId);
  }

  Future<GameMessage> sendGameMessage(String gameId, String senderId, String text, {String? mediaUrl, String? mediaType}) async {
    return _chatApi.sendGameMessage(gameId, senderId, text, mediaUrl: mediaUrl, mediaType: mediaType);
  }

  Future<List<ChatMessage>> getConversation(String userId1, String userId2) async {
    return _chatApi.getConversation(userId1, userId2);
  }

  Future<ChatMessage> sendChatMessage(String senderId, String receiverId, String text, {String? mediaUrl, String? mediaType}) async {
    return _chatApi.sendChatMessage(senderId, receiverId, text, mediaUrl: mediaUrl, mediaType: mediaType);
  }

  Future<int> getUnreadCount(String userId) async {
    return _chatApi.getUnreadCount(userId);
  }

  Future<void> markAsRead(String messageId) async {
    await _chatApi.markAsRead(messageId);
  }

  Future<void> sendGameReaction(String gameId, String playerId, String reaction) async {
    await _chatApi.sendReaction(gameId, playerId, reaction);
  }

  Future<Map<String, dynamic>> uploadMedia(String filePath) async {
    return _chatApi.uploadMedia(filePath);
  }

  void dispose() {
    _hubService.dispose();
  }
}
