class UserApi {
  Future<Map<String, dynamic>> login(String user, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'id': 'user-$user',
      'email': '$user@example.com',
      'nickname': user,
      'name': 'Nombre de $user',
      'country': 'VE',
      'city': 'Caracas',
    };
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String nickname,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'id': 'user-$nickname',
      'email': email,
      'nickname': nickname,
      'name': null,
      'country': null,
      'city': null,
    };
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? name,
    String? country,
    String? city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'id': userId,
      'name': name,
      'country': country,
      'city': city,
    };
  }
}
