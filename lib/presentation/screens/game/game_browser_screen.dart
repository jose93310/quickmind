import 'package:flutter/material.dart';
import '../../../data/models/game_models.dart';
import '../../../data/services/game_service.dart';
import '../game/lobby_screen.dart';
import '../ready/join_game_dialog.dart';

class GameBrowserScreen extends StatefulWidget {
  final GameService gameService;
  final String userId;
  final String nickname;

  const GameBrowserScreen({
    super.key,
    required this.gameService,
    required this.userId,
    required this.nickname,
  });

  @override
  State<GameBrowserScreen> createState() => _GameBrowserScreenState();
}

class _GameBrowserScreenState extends State<GameBrowserScreen> {
  List<PublicGame> _games = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final games = await widget.gameService.getPublicGames();
      setState(() {
        _games = games;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _joinGame(PublicGame game) async {
    try {
      // Unirse a la partida
      final joinedGame = await widget.gameService.joinGame(game.code, widget.userId);

      if (!mounted) return;

      // Navegar al lobby
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyScreen(
            gameService: widget.gameService,
            gameId: joinedGame.id,
            gameCode: joinedGame.code,
            userId: widget.userId,
            isHost: false,
            gameName: game.name,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al unirse: $e')),
      );
    }
  }

  Future<void> _joinByCode() async {
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const JoinGameDialog(),
    );

    if (code != null && code.isNotEmpty) {
      try {
        final game = await widget.gameService.joinGame(code, widget.userId);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LobbyScreen(
              gameService: widget.gameService,
              gameId: game.id,
              gameCode: game.code,
              userId: widget.userId,
              isHost: false,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Partidas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGames,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadGames,
        child: _buildBody(theme),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _joinByCode,
        icon: const Icon(Icons.vpn_key),
        label: const Text('Por código'),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGames,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay partidas públicas disponibles',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta más tarde o crea tu propia partida',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _games.length,
      itemBuilder: (context, index) {
        final game = _games[index];
        return _GameCard(
          game: game,
          onJoin: () => _joinGame(game),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  final PublicGame game;
  final VoidCallback onJoin;

  const _GameCard({
    required this.game,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFull = game.currentPlayers >= game.maxPlayers;
    final isInProgress = game.status == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name != null && game.name!.isNotEmpty
                            ? game.name!
                            : 'Host: ${game.hostNickname}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Código: ${game.code}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(theme),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    game.statusText,
                    style: TextStyle(
                      color: _getStatusTextColor(theme),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${game.currentPlayers}/${game.maxPlayers} jugadores',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.timer,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${game.timePerRound}s por ronda',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${game.totalRounds} rondas',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  game.timeText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (game.scheduledStart != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Inicio: ${_formatDateTime(game.scheduledStart!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (isFull || isInProgress) ? null : onJoin,
                icon: Icon(isInProgress ? Icons.play_arrow : Icons.login),
                label: Text(
                  isInProgress
                      ? 'En curso'
                      : isFull
                          ? 'Llena'
                          : 'Unirse',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (game.status) {
      case 0: // Waiting
        return Colors.green.shade100;
      case 1: // In Progress
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(ThemeData theme) {
    switch (game.status) {
      case 0: // Waiting
        return Colors.green.shade900;
      case 1: // In Progress
        return Colors.orange.shade900;
      default:
        return Colors.grey.shade900;
    }
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year} $hour:$minute';
  }
}
