class Game {
  final String id;
  final String code;
  final String hostId;
  final String? name;
  final int status;
  final int currentRound;
  final int totalRounds;
  final int timePerRound;
  final String? currentLetter;
  final List<Player> players;
  final int maxPlayers;
  final DateTime? scheduledStart;

  Game({
    required this.id,
    required this.code,
    required this.hostId,
    this.name,
    required this.status,
    required this.currentRound,
    required this.totalRounds,
    required this.timePerRound,
    this.currentLetter,
    required this.players,
    this.maxPlayers = 8,
    this.scheduledStart,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      hostId: json['hostId'] ?? '',
      name: json['name'],
      status: json['status'] ?? 0,
      currentRound: json['currentRound'] ?? 0,
      totalRounds: json['totalRounds'] ?? 0,
      timePerRound: json['timePerRound'] ?? 0,
      currentLetter: json['currentLetter'],
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => Player.fromJson(p))
              .toList() ??
          [],
      maxPlayers: json['maxPlayers'] ?? 8,
      scheduledStart: json['scheduledStart'] != null
          ? DateTime.tryParse(json['scheduledStart'])
          : null,
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

class PublicGame {
  final String id;
  final String code;
  final String? name;
  final String hostId;
  final String hostNickname;
  final int status;
  final int currentPlayers;
  final int maxPlayers;
  final int totalRounds;
  final int timePerRound;
  final DateTime? scheduledStart;
  final int minutesUntilStart;

  PublicGame({
    required this.id,
    required this.code,
    this.name,
    required this.hostId,
    required this.hostNickname,
    required this.status,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.totalRounds,
    required this.timePerRound,
    this.scheduledStart,
    required this.minutesUntilStart,
  });

  factory PublicGame.fromJson(Map<String, dynamic> json) {
    return PublicGame(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'],
      hostId: json['hostId'] ?? '',
      hostNickname: json['hostNickname'] ?? '',
      status: json['status'] ?? 0,
      currentPlayers: json['currentPlayers'] ?? 0,
      maxPlayers: json['maxPlayers'] ?? 0,
      totalRounds: json['totalRounds'] ?? 0,
      timePerRound: json['timePerRound'] ?? 0,
      scheduledStart: json['scheduledStart'] != null 
          ? DateTime.tryParse(json['scheduledStart']) 
          : null,
      minutesUntilStart: json['minutesUntilStart'] ?? 0,
    );
  }

  String get statusText {
    switch (status) {
      case 0:
        return 'Esperando';
      case 1:
        return 'En curso';
      case 2:
        return 'Finalizada';
      default:
        return 'Desconocido';
    }
  }

  String get timeText {
    if (status == 1) return 'Jugando ahora';
    if (scheduledStart == null) return 'Inmediato';
    if (minutesUntilStart <= 0) return 'Comenzando...';
    if (minutesUntilStart < 60) return 'En $minutesUntilStart min';
    return 'En ${minutesUntilStart ~/ 60}h ${minutesUntilStart % 60}m';
  }
}

enum GameStatus { waiting, inProgress, finished, cancelled }
enum LetterMode { random, manual }
enum ValidationType { manual, voting, ai }

// ===== Friend Models =====

class Friend {
  final String id;
  final String nickname;
  final String? avatarPath;
  final bool isOnline;

  Friend({
    required this.id,
    required this.nickname,
    this.avatarPath,
    this.isOnline = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarPath: json['avatarPath'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}

class FriendRequest {
  final String id;
  final String senderId;
  final String senderNickname;
  final String? senderAvatarPath;
  final String receiverId;
  final int status;
  final DateTime createdAt;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.senderNickname,
    this.senderAvatarPath,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderNickname: json['senderNickname'] as String,
      senderAvatarPath: json['senderAvatarPath'] as String?,
      receiverId: json['receiverId'] as String,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class UserSearchResult {
  final String id;
  final String nickname;
  final String? avatarPath;
  final bool isFriend;
  final bool hasPendingRequest;

  UserSearchResult({
    required this.id,
    required this.nickname,
    this.avatarPath,
    required this.isFriend,
    required this.hasPendingRequest,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarPath: json['avatarPath'] as String?,
      isFriend: json['isFriend'] as bool,
      hasPendingRequest: json['hasPendingRequest'] as bool,
    );
  }
}

class GameInvite {
  final String gameId;
  final String gameCode;
  final String hostNickname;
  final String invitedUserId;

  GameInvite({
    required this.gameId,
    required this.gameCode,
    required this.hostNickname,
    required this.invitedUserId,
  });

  factory GameInvite.fromJson(Map<String, dynamic> json) {
    return GameInvite(
      gameId: json['gameId'] as String,
      gameCode: json['gameCode'] as String,
      hostNickname: json['hostNickname'] as String,
      invitedUserId: json['invitedUserId'] as String,
    );
  }
}

// ===== Chat Models =====

class GameMessage {
  final String id;
  final String gameId;
  final String senderId;
  final String senderNickname;
  final String? text;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime createdAt;

  GameMessage({
    required this.id,
    required this.gameId,
    required this.senderId,
    required this.senderNickname,
    this.text,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
  });

  factory GameMessage.fromJson(Map<String, dynamic> json) {
    return GameMessage(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      senderId: json['senderId'] as String,
      senderNickname: json['senderNickname'] as String,
      text: json['text'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderNickname;
  final String receiverId;
  final String? text;
  final String? mediaUrl;
  final String? mediaType;
  final bool isRead;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderNickname,
    required this.receiverId,
    this.text,
    this.mediaUrl,
    this.mediaType,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderNickname: json['senderNickname'] as String,
      receiverId: json['receiverId'] as String,
      text: json['text'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class GameReaction {
  final String id;
  final String gameId;
  final String playerId;
  final String playerNickname;
  final String reaction;
  final DateTime createdAt;

  GameReaction({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.playerNickname,
    required this.reaction,
    required this.createdAt,
  });

  factory GameReaction.fromJson(Map<String, dynamic> json) {
    return GameReaction(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      playerId: json['playerId'] as String,
      playerNickname: json['playerNickname'] as String,
      reaction: json['reaction'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
