import 'package:drift/drift.dart';
import '../app_database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertUser(UsersCompanion data) =>
      into(users).insertOnConflictUpdate(data);

  Future<void> deleteUser(String id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  Stream<User?> watchUser(String id) {
    return (select(users)..where((u) => u.id.equals(id))).watchSingleOrNull();
  }
}
