import 'package:dio/dio.dart';
import '../models/game_models.dart';
import '../../core/constants/api_constants.dart';

class ChatApi {
  final Dio _dio;

  ChatApi(this._dio);

  Future<List<GameMessage>> getGameMessages(String gameId) async {
    try {
      final response = await _dio.get(ApiConstants.chatGameMessages(gameId));
      return (response.data as List)
          .map((m) => GameMessage.fromJson(m))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<GameMessage> sendGameMessage(String gameId, String senderId, String text, {String? mediaUrl, String? mediaType}) async {
    try {
      final response = await _dio.post(
        ApiConstants.chatGame,
        data: {
          'gameId': gameId,
          'senderId': senderId,
          'text': text,
          'mediaUrl': mediaUrl,
          'mediaType': mediaType,
        },
      );
      return GameMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ChatMessage>> getConversation(String userId1, String userId2) async {
    try {
      final response = await _dio.get(ApiConstants.chatConversation(userId1, userId2));
      return (response.data as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChatMessage> sendChatMessage(String senderId, String receiverId, String text, {String? mediaUrl, String? mediaType}) async {
    try {
      final response = await _dio.post(
        ApiConstants.chatDirect,
        data: {
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'mediaUrl': mediaUrl,
          'mediaType': mediaType,
        },
      );
      return ChatMessage.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.chatUnread(userId));
      return response.data as int;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _dio.post(ApiConstants.chatRead(messageId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> sendReaction(String gameId, String playerId, String reaction) async {
    try {
      await _dio.post(
        ApiConstants.chatReaction,
        data: {
          'gameId': gameId,
          'playerId': playerId,
          'reaction': reaction,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> uploadMedia(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        ApiConstants.uploadMedia,
        data: formData,
      );
      return response.data as Map<String, dynamic>;
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
