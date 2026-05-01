class AuthApi {
  Future<Map<String, dynamic>> login(String user, String password) async {
    // Simulación temporal (mock)
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'id': 'mock-user-id',
      'email': '$user@example.com',
      'nickname': user,
    };
  }
}
