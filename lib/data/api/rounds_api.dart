class RoundsApi {
  Future<List<Map<String, dynamic>>> fetchRounds(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 1,
        'userId': userId,
        'category': 'Animales',
        'score': 10,
        'timeSpent': 25,
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 2,
        'userId': userId,
        'category': 'Países',
        'score': 15,
        'timeSpent': 30,
        'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];
  }
}
