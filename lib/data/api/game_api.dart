import 'package:dio/dio.dart';
import '../models/game_models.dart';
import '../../core/constants/api_constants.dart';

class GameApi {
  final Dio _dio;

  GameApi(this._dio);

  Future<Game> createGame({
    required String hostId,
    required int maxPlayers,
    required int totalRounds,
    required int timePerRound,
    required int letterMode,
    required int validationType,
    required List<int> categoryIds,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.games,
        data: {
          'hostId': hostId,
          'maxPlayers': maxPlayers,
          'totalRounds': totalRounds,
          'timePerRound': timePerRound,
          'letterMode': letterMode,
          'validationType': validationType,
          'categoryIds': categoryIds,
        },
      );
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Game> getGame(String gameId) async {
    try {
      final response = await _dio.get(ApiConstants.gameById(gameId));
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Game> getGameByCode(String code) async {
    try {
      final response = await _dio.get(ApiConstants.gameByCode(code));
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Game> joinGame(String gameCode, String userId) async {
    try {
      final response = await _dio.post(
        ApiConstants.joinGame,
        data: {
          'gameCode': gameCode,
          'userId': userId,
        },
      );
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> startGame(String gameId, String hostId) async {
    try {
      await _dio.post(
        ApiConstants.startGame(gameId),
        data: hostId,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> stopRound(String gameId, String playerId) async {
    try {
      await _dio.post(
        ApiConstants.stopRound(gameId),
        data: playerId,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> submitAnswer({
    required String roundId,
    required String playerId,
    required String category,
    required String text,
  }) async {
    try {
      await _dio.post(
        ApiConstants.submitAnswer,
        data: {
          'roundId': roundId,
          'playerId': playerId,
          'category': category,
          'text': text,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> vote({
    required String answerId,
    required bool isValid,
    required String voterId,
  }) async {
    try {
      await _dio.post(
        '${ApiConstants.vote}?voterId=$voterId',
        data: {
          'answerId': answerId,
          'isValid': isValid,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Category>> getCategories({int? ageGroup}) async {
    try {
      final response = await _dio.get(
        ApiConstants.categories,
        queryParameters: ageGroup != null ? {'ageGroup': ageGroup} : null,
      );
      return (response.data as List)
          .map((c) => Category.fromJson(c))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('error')) {
        return Exception(data['error']);
      }
      return Exception('Error ${e.response?.statusCode}: ${e.message}');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
