class LoginResponse {
  final String userId;
  final String nickname;
  final String email;
  final String token;
  final bool isGuest;

  LoginResponse({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.token,
    required this.isGuest,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      isGuest: json['isGuest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'email': email,
      'token': token,
      'isGuest': isGuest,
    };
  }
}

class User {
  final String id;
  final String email;
  final String nickname;
  final String? name;
  final String? country;
  final String? city;
  final DateTime? birthDate;
  final String? gender;
  final String? avatarPath;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.name,
    this.country,
    this.city,
    this.birthDate,
    this.gender,
    this.avatarPath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      name: json['name'],
      country: json['country'],
      city: json['city'],
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate']) : null,
      gender: json['gender'],
      avatarPath: json['avatarPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'name': name,
      'country': country,
      'city': city,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'avatarPath': avatarPath,
    };
  }
}
