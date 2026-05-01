import 'package:quickmind/data/api/stats_api.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/data/db/daos/stats_dao.dart';
import 'package:quickmind/storage/session_storage.dart';

class StatsRepository {
  final StatsDao dao;
  final StatsApi api;

  StatsRepository({
    required this.dao,
    required this.api,
  });

  Future<UserStat?> getCurrentStats() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return null;

    final local = await dao.getStats(userId);
    if (local != null) return local;

    final remote = await api.fetchStats(userId);
    final inserted = UserStatsCompanion.insert(
      userId: userId,
      gamesPlayed: remote['gamesPlayed'],
      roundsPlayed: remote['roundsPlayed'],
      validAnswers: remote['validAnswers'],
      invalidAnswers: remote['invalidAnswers'],
      bestScore: remote['bestScore'],
    );
    await dao.updateStats(inserted);
    return dao.getStats(userId);
  }

  Future<void> incrementGames() async {
    final userId = await SessionStorage.getUserId();
    if (userId == null) return;
    await dao.incrementGames(userId);
  }
}
