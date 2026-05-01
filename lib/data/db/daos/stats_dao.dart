import 'package:drift/drift.dart';
import '../app_database.dart';

part 'stats_dao.g.dart';

@DriftAccessor(tables: [UserStats])
class StatsDao extends DatabaseAccessor<AppDatabase> with _$StatsDaoMixin {
  StatsDao(AppDatabase db) : super(db);

  Future<UserStat?> getStats(String userId) {
    return (select(userStats)..where((s) => s.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> updateStats(UserStatsCompanion data) =>
      into(userStats).insertOnConflictUpdate(data);

  Future<void> incrementGames(String userId) async {
    final stats = await getStats(userId);
    final updated = UserStatsCompanion(
      id: Value(stats!.id),
      userId: Value(userId),
      gamesPlayed: Value(stats.gamesPlayed + 1),
    );
    await updateStats(updated);
  }
}
