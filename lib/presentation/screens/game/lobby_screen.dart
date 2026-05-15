import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/game_models.dart';
import '../../../data/services/game_service.dart';
import '../../../data/services/game_hub_service.dart';
import '../rounds/stop_round_screen.dart';
import '../chat/chat_widget.dart';
import 'game_config_screen.dart';

class LobbyScreen extends StatefulWidget {
  final GameService gameService;
  final String gameId;
  final String gameCode;
  final String userId;
  final bool isHost;
  final String? gameName;

  const LobbyScreen({
    super.key,
    required this.gameService,
    required this.gameId,
    required this.gameCode,
    required this.userId,
    required this.isHost,
    this.gameName,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  Game? game;
  bool isLoading = true;
  String? errorMessage;
  StreamSubscription<GameEvent>? _eventSubscription;
  final List<String> _events = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Conectar al hub
      await widget.gameService.connect();
      
      // Unirse al juego en el hub
      await widget.gameService.joinGameHub(
        widget.gameCode, 
        widget.userId, 
        'Player', // TODO: Obtener nickname real
      );
      
      // Escuchar eventos
      _eventSubscription = widget.gameService.gameEvents.listen(_handleGameEvent);
      
      // Cargar estado inicial
      await _loadGame();
    } catch (e) {
      setState(() {
        errorMessage = 'Error al conectar: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadGame() async {
    try {
      final gameData = await widget.gameService.getGame(widget.gameId);
      setState(() {
        game = gameData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error cargando partida: $e';
        isLoading = false;
      });
    }
  }

  void _handleGameEvent(GameEvent event) {
    setState(() {
      if (event is PlayerJoinedEvent) {
        _events.add('${event.nickname} se unió');
        _loadGame(); // Recargar lista
      } else if (event is PlayerLeftEvent) {
        _events.add('Un jugador salió');
        _loadGame();
      } else if (event is GameStartedEvent) {
        _events.add('¡La partida comenzó! Letra: ${event.letter}');
        _navigateToGame(event.letter);
      } else if (event is GameConnectionLost) {
        _events.add('Conexión perdida...');
      } else if (event is GameConnectionRestored) {
        _events.add('Conexión restaurada');
      }
      
      // Mantener solo últimos 5 eventos
      if (_events.length > 5) _events.removeAt(0);
    });
  }

  void _navigateToGame(String letter) {
    // Navegar a la pantalla de juego con los parámetros disponibles
    // TODO: Pasar las categorías seleccionadas desde el backend
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => StopRoundScreen(
          letter: letter,
          categories: const ['Nombre', 'Animal', 'País', 'Color', 'Comida'], // Temporal
          timeLimitEnabled: true,
        ),
      ),
    );
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ChatWidget(
            gameService: widget.gameService,
            currentUserId: widget.userId,
            gameId: widget.gameId,
            title: 'Chat de Sala',
            showReactions: true,
          ),
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    try {
      setState(() => isLoading = true);
      await widget.gameService.startGame(widget.gameId, widget.userId);
      // El evento GameStarted navegará automáticamente
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _leaveGame() async {
    try {
      await widget.gameService.leaveGameHub(widget.gameCode, widget.userId);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error al salir: $e');
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lobby')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Conectando al servidor...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lobby')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initialize,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final players = game?.players ?? [];
    final isReadyToStart = players.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName != null && widget.gameName!.isNotEmpty
            ? widget.gameName!
            : 'Lobby de Partida'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _leaveGame,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openChat(),
        icon: const Icon(Icons.chat),
        label: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Código de partida
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Código de Partida',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.gameCode,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            // Copiar al portapapeles
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Código copiado')),
                            );
                          },
                          tooltip: 'Copiar código',
                        ),
                      ],
                    ),
                    Text(
                      'Comparte este código para invitar jugadores',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Configuración
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Configuración',
                          style: theme.textTheme.titleSmall,
                        ),
                        if (widget.isHost)
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GameConfigScreen(
                                    gameService: widget.gameService,
                                    userId: widget.userId,
                                    nickname: '',
                                    editGameId: widget.gameId,
                                    editGameName: widget.gameName,
                                    editMaxPlayers: game?.maxPlayers,
                                    editTotalRounds: game?.totalRounds,
                                    editTimePerRound: game?.timePerRound,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Editar', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (widget.gameName != null && widget.gameName!.isNotEmpty)
                      _buildConfigRow('Nombre:', widget.gameName!),
                    if (game?.scheduledStart != null)
                      _buildConfigRow('Inicio:', _formatDateTime(game!.scheduledStart!)),
                    _buildConfigRow('Rondas:', '${game?.totalRounds ?? 0}'),
                    _buildConfigRow('Tiempo por ronda:', '${game?.timePerRound ?? 0}s'),
                    _buildConfigRow('Jugadores:', '${players.length}/${game?.maxPlayers ?? 0}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de jugadores
            Text(
              'Jugadores Conectados',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(player.nickname[0].toUpperCase()),
                      ),
                      title: Text(player.nickname),
                      subtitle: player.isHost ? const Text('Host') : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (player.isHost)
                            const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: player.isOnline ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Eventos en tiempo real
            if (_events.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _events
                      .map((e) => Text(
                            '• $e',
                            style: theme.textTheme.bodySmall,
                          ))
                      .toList(),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Botón de iniciar (solo host)
            if (widget.isHost) ...[
              ElevatedButton.icon(
                onPressed: isReadyToStart ? _startGame : null,
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  isReadyToStart 
                      ? 'Iniciar Partida' 
                      : 'Esperando más jugadores...',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isReadyToStart 
                      ? theme.colorScheme.primary 
                      : Colors.grey,
                ),
              ),
              if (!isReadyToStart)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Se necesitan al menos 2 jugadores',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
            ] else ...[
              const Center(
                child: Text(
                  'Esperando que el host inicie la partida...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year} $hour:$minute';
  }
}
