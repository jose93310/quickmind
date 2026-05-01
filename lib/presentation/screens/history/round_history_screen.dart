import 'package:flutter/material.dart';
import 'package:quickmind/core/game/game_controller.dart';

class RoundHistoryScreen extends StatelessWidget {
  const RoundHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameController();
    final usedLetters = game.usedLetters;

    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Rondas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: usedLetters.isEmpty
            ? Center(
                child: Text(
                  'Aún no hay rondas registradas',
                  style: theme.textTheme.titleMedium,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Letras jugadas',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: usedLetters.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final letter = usedLetters[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.primaryContainer,
                            child: Text(
                              letter,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: color.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            'Ronda ${index + 1}',
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
