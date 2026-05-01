import 'package:quickmind/data/api/rounds_api.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/data/db/daos/rounds_dao.dart';
import 'package:quickmind/storage/session_storage.dart';

class RoundsRepository {
  final RoundsDao dao;
  final RoundsApi api;

  RoundsRepository({
    required this.dao,
    required this.api,
  });

  Future<void> saveRound({
    required String category,
    required int score,
    required int timeSpent,
  }) async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return;

    await dao.insertRound(
      RoundsCompanion.insert(
        userId: userId,
        category: category,
        score: score,
        timeSpent: timeSpent,
        date: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<List<Round>> getHistory() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return [];
    return dao.getRoundsByUser(userId);
  }

  Future<void> syncFromRemote() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return;

    final remote = await api.fetchRounds(userId);
    for (final r in remote) {
      await dao.insertRound(
        RoundsCompanion.insert(
          userId: r['userId'],
          category: r['category'],
          score: r['score'],
          timeSpent: r['timeSpent'],
          date: r['date'],
        ),
      );
    }
  }
}
