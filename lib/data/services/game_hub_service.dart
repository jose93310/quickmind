import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/game_models.dart';

/// Servicio para manejar la conexión SignalR con el servidor de juego
class GameHubService {
  HubConnection? _hubConnection;
  final StreamController<GameEvent> _eventController = StreamController<GameEvent>.broadcast();
  final StreamController<FriendEvent> _friendEventController = StreamController<FriendEvent>.broadcast();
  final StreamController<GameInvite> _inviteController = StreamController<GameInvite>.broadcast();
  final StreamController<ChatEvent> _chatEventController = StreamController<ChatEvent>.broadcast();
  
  // Stream para escuchar eventos del juego
  Stream<GameEvent> get gameEvents => _eventController.stream;
  Stream<FriendEvent> get friendEvents => _friendEventController.stream;
  Stream<GameInvite> get gameInvites => _inviteController.stream;
  Stream<ChatEvent> get chatEvents => _chatEventController.stream;
  
  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  /// Inicializa la conexión SignalR
  Future<void> connect() async {
    if (_hubConnection != null && isConnected) {
      return; // Ya conectado
    }

    // Crear conexión
    _hubConnection = HubConnectionBuilder()
        .withUrl('${ApiConstants.serverUrl}/gamehub')
        .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 20000])
        .build();

    // Configurar handlers de eventos
    _setupEventHandlers();

    // Manejar cambios de estado
    _hubConnection!.onclose(({error}) {
      print('SignalR cerrado: $error');
      _eventController.add(GameConnectionLost(error?.toString()));
    });

    _hubConnection!.onreconnecting(({error}) {
      print('SignalR reconectando...');
      _eventController.add(GameConnectionReconnecting());
    });

    _hubConnection!.onreconnected(({connectionId}) {
      print('SignalR reconectado: $connectionId');
      _eventController.add(GameConnectionRestored());
    });

    try {
      await _hubConnection!.start();
      print('SignalR conectado');
      _eventController.add(GameConnected());
    } catch (e) {
      print('Error conectando SignalR: $e');
      _eventController.add(GameConnectionError(e.toString()));
      rethrow;
    }
  }

  /// Configura los handlers para eventos del servidor
  void _setupEventHandlers() {
    // Un jugador se unió a la partida
    _hubConnection!.on('PlayerJoined', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final playerData = args[0] as Map<dynamic, dynamic>?;
        if (playerData != null) {
          _eventController.add(PlayerJoinedEvent(
            playerId: playerData['id']?.toString() ?? '',
            nickname: playerData['nickname']?.toString() ?? '',
          ));
        }
      }
    });

    // Un jugador salió de la partida
    _hubConnection!.on('PlayerLeft', (args) {
      if (args != null && args.isNotEmpty) {
        _eventController.add(PlayerLeftEvent(
          playerId: args[0].toString(),
        ));
      }
    });

    // La partida inició
    _hubConnection!.on('GameStarted', (args) {
      if (args != null && args.length >= 3) {
        _eventController.add(GameStartedEvent(
          letter: args[0].toString(),
          currentRound: int.tryParse(args[1].toString()) ?? 1,
          totalRounds: int.tryParse(args[2].toString()) ?? 1,
        ));
      }
    });

    // Alguien presionó STOP
    _hubConnection!.on('RoundStopped', (args) {
      if (args != null && args.isNotEmpty) {
        _eventController.add(RoundStoppedEvent(
          playerId: args[0].toString(),
        ));
      }
    });

    // Un jugador envió una respuesta
    _hubConnection!.on('PlayerAnswered', (args) {
      if (args != null && args.length >= 2) {
        _eventController.add(PlayerAnsweredEvent(
          playerId: args[0].toString(),
          category: args[1].toString(),
        ));
      }
    });

    // Resultados de la ronda listos
    _hubConnection!.on('RoundResultsReady', (args) {
      _eventController.add(RoundResultsReadyEvent());
    });

    // La partida terminó
    _hubConnection!.on('GameFinished', (args) {
      if (args != null && args.isNotEmpty) {
        final scores = (args[0] as List<dynamic>?)
            ?.map((p) => PlayerScore(
                  playerId: p['id']?.toString() ?? '',
                  nickname: p['nickname']?.toString() ?? '',
                  score: int.tryParse(p['score'].toString()) ?? 0,
                ))
            .toList() ?? [];
        _eventController.add(GameFinishedEvent(scores: scores));
      }
    });

    // ===== Friend Events =====
    
    // Solicitud de amistad recibida
    _hubConnection!.on('FriendRequestReceived', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final data = args[0] as Map<dynamic, dynamic>?;
        if (data != null) {
          _friendEventController.add(FriendRequestReceivedEvent(
            request: FriendRequest.fromJson(Map<String, dynamic>.from(data)),
          ));
        }
      }
    });

    // Solicitud de amistad respondida
    _hubConnection!.on('FriendRequestResponded', (args) {
      if (args != null && args.length >= 2) {
        _friendEventController.add(FriendRequestRespondedEvent(
          requestId: args[0].toString(),
          accepted: args[1] as bool,
        ));
      }
    });

    // Invitación a partida recibida
    _hubConnection!.on('GameInviteReceived', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final data = args[0] as Map<dynamic, dynamic>?;
        if (data != null) {
          _inviteController.add(GameInvite.fromJson(Map<String, dynamic>.from(data)));
        }
      }
    });

    // Cambio de estado online de un amigo
    _hubConnection!.on('UserOnlineStatusChanged', (args) {
      if (args != null && args.length >= 2) {
        _friendEventController.add(UserOnlineStatusChangedEvent(
          userId: args[0].toString(),
          isOnline: args[1] as bool,
        ));
      }
    });

    // ===== Chat Events =====
    
    // Mensaje de sala de juego recibido
    _hubConnection!.on('GameMessageReceived', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final data = args[0] as Map<dynamic, dynamic>?;
        if (data != null) {
          _chatEventController.add(GameMessageReceivedEvent(
            message: GameMessage.fromJson(Map<String, dynamic>.from(data)),
          ));
        }
      }
    });

    // Mensaje directo recibido
    _hubConnection!.on('ChatMessageReceived', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final data = args[0] as Map<dynamic, dynamic>?;
        if (data != null) {
          _chatEventController.add(ChatMessageReceivedEvent(
            message: ChatMessage.fromJson(Map<String, dynamic>.from(data)),
          ));
        }
      }
    });

    // Reacción durante partida recibida
    _hubConnection!.on('GameReactionReceived', (args) {
      if (args != null && args.isNotEmpty && args[0] != null) {
        final data = args[0] as Map<dynamic, dynamic>?;
        if (data != null) {
          _chatEventController.add(GameReactionReceivedEvent(
            reaction: GameReaction.fromJson(Map<String, dynamic>.from(data)),
          ));
        }
      }
    });
  }

  /// Unirse al grupo de usuario personal
  Future<void> joinUserGroup(String userId) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('JoinUserGroup', args: [userId]);
  }

  /// Unirse a una partida (llamar al hub)
  Future<void> joinGame(String gameCode, String playerId, String nickname) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('JoinGame', args: [
      gameCode,
      {'id': playerId, 'nickname': nickname}
    ]);
  }

  /// Salir de una partida
  Future<void> leaveGame(String gameCode, String playerId) async {
    if (!isConnected) return;
    
    await _hubConnection!.invoke('LeaveGame', args: [gameCode, playerId]);
  }

  /// Notificar que se presionó STOP
  Future<void> stopRound(String gameCode) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('StopRound', args: [gameCode]);
  }

  /// Enviar invitación a partida
  Future<void> sendGameInvite(String gameId, String gameCode, String hostNickname, String invitedUserId) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('SendGameInvite', args: [
      {
        'gameId': gameId,
        'gameCode': gameCode,
        'hostNickname': hostNickname,
        'invitedUserId': invitedUserId,
      }
    ]);
  }

  /// Enviar mensaje a sala de juego (vía SignalR para inmediato + API para persistencia)
  Future<void> sendGameMessage(String gameId, String senderId, String text) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('SendGameMessage', args: [
      {
        'gameId': gameId,
        'senderId': senderId,
        'text': text,
      }
    ]);
  }

  /// Enviar reacción durante partida
  Future<void> sendGameReaction(String gameId, String playerId, String reaction) async {
    if (!isConnected) {
      throw Exception('No conectado al servidor');
    }
    
    await _hubConnection!.invoke('SendReaction', args: [
      {
        'gameId': gameId,
        'playerId': playerId,
        'reaction': reaction,
      }
    ]);
  }

  /// Desconectar
  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _hubConnection = null;
    }
  }

  void dispose() {
    disconnect();
    _eventController.close();
    _friendEventController.close();
    _inviteController.close();
    _chatEventController.close();
  }
}

/// Clases de eventos del juego
abstract class GameEvent {}

class GameConnected extends GameEvent {}
class GameConnectionLost extends GameEvent {
  final String? error;
  GameConnectionLost(this.error);
}
class GameConnectionReconnecting extends GameEvent {}
class GameConnectionRestored extends GameEvent {}
class GameConnectionError extends GameEvent {
  final String error;
  GameConnectionError(this.error);
}

class PlayerJoinedEvent extends GameEvent {
  final String playerId;
  final String nickname;
  PlayerJoinedEvent({required this.playerId, required this.nickname});
}

class PlayerLeftEvent extends GameEvent {
  final String playerId;
  PlayerLeftEvent({required this.playerId});
}

class GameStartedEvent extends GameEvent {
  final String letter;
  final int currentRound;
  final int totalRounds;
  GameStartedEvent({
    required this.letter,
    required this.currentRound,
    required this.totalRounds,
  });
}

class RoundStoppedEvent extends GameEvent {
  final String playerId;
  RoundStoppedEvent({required this.playerId});
}

class PlayerAnsweredEvent extends GameEvent {
  final String playerId;
  final String category;
  PlayerAnsweredEvent({required this.playerId, required this.category});
}

class RoundResultsReadyEvent extends GameEvent {}

class GameFinishedEvent extends GameEvent {
  final List<PlayerScore> scores;
  GameFinishedEvent({required this.scores});
}

class PlayerScore {
  final String playerId;
  final String nickname;
  final int score;
  PlayerScore({
    required this.playerId,
    required this.nickname,
    required this.score,
  });
}

/// Clases de eventos de amigos
abstract class FriendEvent {}

class FriendRequestReceivedEvent extends FriendEvent {
  final FriendRequest request;
  FriendRequestReceivedEvent({required this.request});
}

class FriendRequestRespondedEvent extends FriendEvent {
  final String requestId;
  final bool accepted;
  FriendRequestRespondedEvent({required this.requestId, required this.accepted});
}

class UserOnlineStatusChangedEvent extends FriendEvent {
  final String userId;
  final bool isOnline;
  UserOnlineStatusChangedEvent({required this.userId, required this.isOnline});
}

/// Clases de eventos de chat
abstract class ChatEvent {}

class GameMessageReceivedEvent extends ChatEvent {
  final GameMessage message;
  GameMessageReceivedEvent({required this.message});
}

class ChatMessageReceivedEvent extends ChatEvent {
  final ChatMessage message;
  ChatMessageReceivedEvent({required this.message});
}

class GameReactionReceivedEvent extends ChatEvent {
  final GameReaction reaction;
  GameReactionReceivedEvent({required this.reaction});
}
