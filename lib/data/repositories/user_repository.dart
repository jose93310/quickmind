import 'package:drift/drift.dart';
import '../api/user_api.dart';
import '../db/app_database.dart';
import '../models/auth_models.dart' as api_models;
import '../../storage/session_storage.dart';

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
        id: data.userId,
        email: data.email,
        nickname: data.nickname,
      ),
    );

    // Guardar sesión
    await SessionStorage.saveSession(
      userId: data.userId,
      isGuest: data.isGuest,
    );
  }

  Future<api_models.User?> getCurrentUser() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return null;

    // Intentar obtener de la API primero
    try {
      final user = await api.getCurrentUser(userId);
      
      // Actualizar en BD local
      await db.into(db.users).insertOnConflictUpdate(
        UsersCompanion.insert(
          id: user.id,
          email: user.email,
          nickname: user.nickname,
          name: Value(user.name),
          country: Value(user.country),
          city: Value(user.city),
        ),
      );
      
      return user;
    } catch (e) {
      // Si falla, obtener de BD local
      final query = await (db.select(db.users)
            ..where((tbl) => tbl.id.equals(userId)))
          .getSingleOrNull();
      
      if (query == null) return null;
      
      return api_models.User(
        id: query.id,
        email: query.email,
        nickname: query.nickname,
        name: query.name,
        country: query.country,
        city: query.city,
        birthDate: query.birthDate != null ? DateTime.tryParse(query.birthDate!) : null,
        gender: query.gender,
        avatarPath: query.avatarPath,
      );
    }
  }

  Future<api_models.User> updateProfile(String userId, {String? name, String? country, String? city}) async {
    final user = await api.updateProfile(userId, name: name, country: country, city: city);
    
    // Actualizar en BD local
    await db.into(db.users).insertOnConflictUpdate(
      UsersCompanion.insert(
        id: user.id,
        email: user.email,
        nickname: user.nickname,
        name: Value(user.name),
        country: Value(user.country),
        city: Value(user.city),
      ),
    );
    
    return user;
  }
}
