import 'dart:async';
import '../api/game_api.dart';
import '../models/game_models.dart';
import 'game_hub_service.dart';

/// Servicio principal que combina API REST + SignalR para el juego
class GameService {
  final GameApi _gameApi;
  final GameHubService _hubService;
  
  // Streams para el UI
  Stream<GameEvent> get gameEvents => _hubService.gameEvents;
  bool get isHubConnected => _hubService.isConnected;

  GameService({
    required GameApi gameApi,
    required GameHubService hubService,
  })  : _gameApi = gameApi,
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
  }) async {
    return _gameApi.createGame(
      hostId: hostId,
      maxPlayers: maxPlayers,
      totalRounds: totalRounds,
      timePerRound: timePerRound,
      letterMode: letterMode.index,
      validationType: validationType.index,
      categoryIds: categoryIds,
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

  // ===== SignalR Calls =====

  Future<void> joinGameHub(String gameCode, String playerId, String nickname) async {
    await _hubService.joinGame(gameCode, playerId, nickname);
  }

  Future<void> leaveGameHub(String gameCode, String playerId) async {
    await _hubService.leaveGame(gameCode, playerId);
  }

  void dispose() {
    _hubService.dispose();
  }
}
