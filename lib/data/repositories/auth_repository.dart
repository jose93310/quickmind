import '../api/auth_api.dart';
import '../db/app_database.dart';
import '../models/auth_models.dart';
import '../../storage/session_storage.dart';

class AuthRepository {
  final AuthApi _api;
  final AppDatabase _db;

  AuthRepository({
    required AuthApi api,
    required AppDatabase db,
  })  : _api = api,
        _db = db;

  Future<LoginResponse> login(String email, String password) async {
    final response = await _api.login(email, password);
    await _saveUserAndSession(response);
    return response;
  }

  Future<LoginResponse> register({
    required String email,
    required String nickname,
    required String password,
  }) async {
    final response = await _api.register(email, nickname, password);
    await _saveUserAndSession(response);
    return response;
  }

  Future<LoginResponse> guestLogin(String nickname) async {
    final response = await _api.guestLogin(nickname);
    await _saveUserAndSession(response);
    return response;
  }

  Future<void> logout() async {
    await SessionStorage.clearSession();
  }

  Future<bool> isLoggedIn() async {
    return await SessionStorage.isLoggedIn();
  }

  Future<bool> isGuest() async {
    return await SessionStorage.isGuest();
  }

  Future<String?> getCurrentUserId() async {
    return await SessionStorage.getUserId();
  }

  Future<void> _saveUserAndSession(LoginResponse response) async {
    // Guardar en base de datos local
    await _db.into(_db.users).insertOnConflictUpdate(
      UsersCompanion.insert(
        id: response.userId,
        email: response.email,
        nickname: response.nickname,
      ),
    );

    // Guardar sesión
    await SessionStorage.saveSession(
      userId: response.userId,
      isGuest: response.isGuest,
    );
  }
}
