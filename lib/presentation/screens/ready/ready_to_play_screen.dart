import 'package:flutter/material.dart';
import '../../../data/services/game_service.dart';
import '../../../data/models/game_models.dart';
import '../game/lobby_screen.dart';
import '../game/game_browser_screen.dart';
import '../game/game_config_screen.dart';
import 'join_game_dialog.dart';

class ReadyToPlayScreen extends StatefulWidget {
  final GameService gameService;
  final String userId;
  final String nickname;

  const ReadyToPlayScreen({
    super.key,
    required this.gameService,
    required this.userId,
    required this.nickname,
  });

  @override
  State<ReadyToPlayScreen> createState() => _ReadyToPlayScreenState();
}

class _ReadyToPlayScreenState extends State<ReadyToPlayScreen> {
  bool isLoading = false;
  List<PublicGame> _myGames = [];
  bool _loadingGames = true;

  @override
  void initState() {
    super.initState();
    _loadMyGames();
  }

  Future<void> _loadMyGames() async {
    try {
      final publicGames = await widget.gameService.getPublicGames();
      final myGames = publicGames
          .where((g) => g.status != 2 && 
                         g.hostNickname == widget.nickname)
          .toList();
      setState(() {
        _myGames = myGames;
        _loadingGames = false;
      });
    } catch (e) {
      setState(() => _loadingGames = false);
    }
  }

  void _createGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameConfigScreen(
          gameService: widget.gameService,
          userId: widget.userId,
          nickname: widget.nickname,
        ),
      ),
    ).then((_) => _loadMyGames());
  }

  Future<void> _joinGame() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const JoinGameDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => isLoading = true);

      try {
        final game = await widget.gameService.joinGame(result, widget.userId);

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al unirse: $e')),
        );
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  void _browsePublicGames() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameBrowserScreen(
          gameService: widget.gameService,
          userId: widget.userId,
          nickname: widget.nickname,
        ),
      ),
    );
  }

  void _joinExistingGame(PublicGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LobbyScreen(
          gameService: widget.gameService,
          gameId: game.id,
          gameCode: game.code,
          userId: widget.userId,
          isHost: false,
          gameName: game.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Listo para jugar')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // PARTIDAS EXISTENTES
                  if (!_loadingGames && _myGames.isNotEmpty) ...[
                    Text(
                      'Tus partidas activas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._myGames.map((game) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: game.status == 1
                                  ? Colors.green
                                  : Colors.orange,
                              child: Icon(
                                game.status == 1
                                    ? Icons.play_arrow
                                    : Icons.hourglass_empty,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              game.name != null && game.name!.isNotEmpty
                                  ? (game.name!.length > 10 
                                      ? '${game.name!.substring(0, 10)}...' 
                                      : game.name!)
                                  : 'Partida ${game.code}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Código: ${game.code}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (game.scheduledStart != null)
                                  Text(
                                    'Inicio: ${_formatDateTime(game.scheduledStart!)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Text(
                                  '${game.currentPlayers}/${game.maxPlayers} jugadores • ${game.totalRounds} rondas • ${game.statusText}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => _joinExistingGame(game),
                          ),
                        )),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // LOADING
                  if (_loadingGames)
                    const Center(child: CircularProgressIndicator()),

                  // BOTÓN CREAR NUEVA PARTIDA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _myGames.length >= 5 ? null : _createGame,
                      icon: const Icon(Icons.add),
                      label: Text(_myGames.length >= 5
                          ? 'Máximo 5 partidas activas'
                          : 'Crear nueva partida'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (_myGames.length >= 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Termina una partida antes de crear otra',
                        style: TextStyle(
                            color: theme.colorScheme.error, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // UNIRSE POR CÓDIGO
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _joinGame,
                      icon: const Icon(Icons.vpn_key),
                      label: const Text('Unirse por código'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // EXPLORAR PÚBLICAS
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _browsePublicGames,
                      icon: const Icon(Icons.public),
                      label: const Text('Explorar partidas públicas'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
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
