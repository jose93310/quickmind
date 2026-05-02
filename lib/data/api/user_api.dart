import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import 'auth_api.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    // Delegar a AuthApi para mantener compatibilidad
    final authApi = AuthApi(_dio);
    return authApi.login(email, password);
  }

  Future<LoginResponse> register(String email, String nickname, String password) async {
    final authApi = AuthApi(_dio);
    return authApi.register(email, nickname, password);
  }

  Future<User> getCurrentUser(String userId) async {
    final authApi = AuthApi(_dio);
    return authApi.getProfile(userId);
  }

  Future<User> updateProfile(String userId, {String? name, String? country, String? city}) async {
    final authApi = AuthApi(_dio);
    return authApi.updateProfile(userId, name: name, country: country, city: city);
  }
}
