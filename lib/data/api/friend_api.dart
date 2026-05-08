import 'package:dio/dio.dart';
import '../models/game_models.dart';
import '../../core/constants/api_constants.dart';

class FriendApi {
  final Dio _dio;

  FriendApi(this._dio);

  Future<void> sendFriendRequest(String senderId, String receiverNickname) async {
    try {
      await _dio.post(
        ApiConstants.friendRequest,
        data: {
          'senderId': senderId,
          'receiverNickname': receiverNickname,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> respondToRequest(String requestId, String userId, bool accept) async {
    try {
      await _dio.post(
        ApiConstants.respondFriendRequest,
        data: {
          'requestId': requestId,
          'userId': userId,
          'accept': accept,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<FriendRequest>> getPendingRequests(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.friendRequests(userId));
      return (response.data as List)
          .map((r) => FriendRequest.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Friend>> getFriends(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.friendsList(userId));
      return (response.data as List)
          .map((f) => Friend.fromJson(f))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFriend(String userId, String friendId) async {
    try {
      await _dio.delete(ApiConstants.removeFriend(userId, friendId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserSearchResult>> searchUsers(String userId, String query) async {
    try {
      final response = await _dio.get(ApiConstants.searchUsers(userId, query));
      return (response.data as List)
          .map((u) => UserSearchResult.fromJson(u))
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
