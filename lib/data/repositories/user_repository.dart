import 'package:drift/drift.dart';
import 'package:quickmind/data/api/user_api.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/storage/session_storage.dart';

class UserRepository {
  final UserApi api;
  final AppDatabase db;

  UserRepository({
    required this.api,
    required this.db,
  });

  Future<void> login(String user, String password) async {
    final data = await api.login(user, password);

    // Guardar en BD local
    await db.into(db.users).insertOnConflictUpdate(
      UsersCompanion.insert(
        id: data['id'],
        email: data['email'],
        nickname: data['nickname'],
        name: Value(data['name']),
        country: Value(data['country']),
        city: Value(data['city']),
        birthDate: const Value(null),
        gender: const Value(null),
        avatarPath: const Value(null),
      ),
    );

    // Guardar sesión
    await SessionStorage.saveSession(
      userId: data['id'],
      isGuest: false,
    );
  }

  Future<User?> getCurrentUser() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return null;

    final query = await (db.select(db.users)
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();

    return query;
  }
}
