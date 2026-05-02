import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import '../../core/constants/api_constants.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoginResponse> register(String email, String nickname, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'email': email, 'nickname': nickname, 'password': password},
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoginResponse> guestLogin(String nickname) async {
    try {
      final response = await _dio.post(
        ApiConstants.guestLogin,
        data: nickname,
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getProfile(String userId) async {
    try {
      final response = await _dio.get('${ApiConstants.profile}/$userId');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile(String userId, {String? name, String? country, String? city}) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.profile}/$userId',
        data: {'name': name, 'country': country, 'city': city},
      );
      return User.fromJson(response.data);
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
