class Game {
  final String id;
  final String code;
  final String hostId;
  final int status;
  final int currentRound;
  final int totalRounds;
  final int timePerRound;
  final String? currentLetter;
  final List<Player> players;

  Game({
    required this.id,
    required this.code,
    required this.hostId,
    required this.status,
    required this.currentRound,
    required this.totalRounds,
    required this.timePerRound,
    this.currentLetter,
    required this.players,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      hostId: json['hostId'] ?? '',
      status: json['status'] ?? 0,
      currentRound: json['currentRound'] ?? 0,
      totalRounds: json['totalRounds'] ?? 0,
      timePerRound: json['timePerRound'] ?? 0,
      currentLetter: json['currentLetter'],
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => Player.fromJson(p))
              .toList() ??
          [],
    );
  }

  bool get isWaiting => status == 0;
  bool get isInProgress => status == 1;
  bool get isFinished => status == 2;
}

class Player {
  final String id;
  final String userId;
  final String nickname;
  final String? avatarPath;
  final int score;
  final bool isHost;
  final bool isOnline;

  Player({
    required this.id,
    required this.userId,
    required this.nickname,
    this.avatarPath,
    required this.score,
    required this.isHost,
    required this.isOnline,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? '',
      avatarPath: json['avatarPath'],
      score: json['score'] ?? 0,
      isHost: json['isHost'] ?? false,
      isOnline: json['isOnline'] ?? false,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String displayName;
  final int ageGroup;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    required this.displayName,
    required this.ageGroup,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      ageGroup: json['ageGroup'] ?? 0,
      icon: json['icon'],
    );
  }

  String get ageGroupName {
    switch (ageGroup) {
      case 0:
        return 'Niños';
      case 1:
        return 'Adolescentes';
      case 2:
        return 'Adultos';
      default:
        return 'General';
    }
  }
}

enum GameStatus { waiting, inProgress, finished, cancelled }
enum LetterMode { random, manual }
enum ValidationType { manual, voting, ai }
