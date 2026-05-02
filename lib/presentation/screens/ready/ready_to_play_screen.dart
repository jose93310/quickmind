import 'package:flutter/material.dart';
import '../../../data/services/game_service.dart';
import '../../../data/models/game_models.dart';
import '../game/lobby_screen.dart';
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

  Future<void> _createGame() async {
    setState(() => isLoading = true);
    
    try {
      // Crear partida con configuración por defecto
      final game = await widget.gameService.createGame(
        hostId: widget.userId,
        maxPlayers: 4,
        totalRounds: 5,
        timePerRound: 120,
        letterMode: LetterMode.random.index,
        validationType: ValidationType.voting.index,
        categoryIds: [1, 2, 3, 4, 5], // Algunas categorías por defecto
      );

      if (!mounted) return;

      // Navegar al lobby
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyScreen(
            gameService: widget.gameService,
            gameId: game.id,
            gameCode: game.code,
            userId: widget.userId,
            isHost: true,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear partida: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _joinGame() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const JoinGameDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => isLoading = true);
      
      try {
        // Unirse a la partida
        final game = await widget.gameService.joinGame(result, widget.userId);

        if (!mounted) return;

        // Navegar al lobby
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
          SnackBar(content: Text('Error al unirse: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listo para jugar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createGame,
                  icon: const Icon(Icons.add),
                  label: const Text('Crear partida'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _joinGame,
                  icon: const Icon(Icons.login),
                  label: const Text('Unirse a partida'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Diálogo para ingresar código
class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({super.key});

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unirse a Partida'),
      content: TextField(
        controller: _codeCtrl,
        decoration: const InputDecoration(
          labelText: 'Código de partida',
          hintText: 'Ej: 123456',
          prefixIcon: Icon(Icons.numbers),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _codeCtrl.text),
          child: const Text('Unirse'),
        ),
      ],
    );
  }
}
