import 'package:drift/drift.dart';
import 'package:quickmind/data/db/app_database.dart';

part 'rounds_dao.g.dart';

@DriftAccessor(tables: [Rounds])
class RoundsDao extends DatabaseAccessor<AppDatabase> with _$RoundsDaoMixin {
  RoundsDao(AppDatabase db) : super(db);

  Future<void> insertRound(RoundsCompanion data) =>
      into(rounds).insert(data);

  Future<List<Round>> getRoundsByUser(String userId) {
    return (select(rounds)..where((r) => r.userId.equals(userId)))
        .get();
  }

  Future<List<Round>> getLastRounds(String userId, int limit) {
    return (select(rounds)
          ..where((r) => r.userId.equals(userId))
          ..orderBy([(r) => OrderingTerm.desc(r.id)])
          ..limit(limit))
        .get();
  }

  Future<void> deleteRounds(String userId) =>
      (delete(rounds)..where((r) => r.userId.equals(userId))).go();
}
