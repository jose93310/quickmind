class StatsApi {
  Future<Map<String, dynamic>> fetchStats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'gamesPlayed': 12,
      'roundsPlayed': 40,
      'validAnswers': 120,
      'invalidAnswers': 30,
      'bestScore': 25,
    };
  }
}
