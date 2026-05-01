import 'package:drift/drift.dart';
import 'package:quickmind/data/api/user_api.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/storage/session_storage.dart';

class AuthRepository {
  final UserApi api;
  final AppDatabase db;

  AuthRepository({
    required this.api,
    required this.db,
  });

  Future<void> login(String user, String password) async {
    final data = await api.login(user, password);

    await db.into(db.users).insertOnConflictUpdate(
      UsersCompanion.insert(
        id: data['id'],
        email: data['email'],
        nickname: data['nickname'],
        name: data['name'] == null ? const Value.absent() : Value(data['name']),
        country: data['country'] == null
            ? const Value.absent()
            : Value(data['country']),
        city: data['city'] == null
            ? const Value.absent()
            : Value(data['city']),
      ),
    );

    await SessionStorage.saveSession(
      userId: data['id'],
      isGuest: false,
    );
  }

  Future<void> register({
    required String email,
    required String nickname,
    required String password,
  }) async {
    final data = await api.register(
      email: email,
      nickname: nickname,
      password: password,
    );

    await db.into(db.users).insertOnConflictUpdate(
      UsersCompanion.insert(
        id: data['id'],
        email: data['email'],
        nickname: data['nickname'],
      ),
    );

    await SessionStorage.saveSession(
      userId: data['id'],
      isGuest: false,
    );
  }

  Future<void> logout() async {
    await SessionStorage.clearSession();
  }
}
