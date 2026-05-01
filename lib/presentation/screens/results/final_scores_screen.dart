import 'package:flutter/material.dart';

class FinalScoresScreen extends StatelessWidget {
  final Map<String, int> scores; // jugador -> puntos

  const FinalScoresScreen({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    // Ordenar jugadores por puntaje
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados finales'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Título principal
            Text(
              'Leaderboard',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),

            const SizedBox(height: 24),

            // Lista de jugadores
            Expanded(
              child: ListView.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = sorted[index];
                  final player = entry.key;
                  final points = entry.value;

                  // Medallas para top 3
                  final medal = switch (index) {
                    0 => '🥇',
                    1 => '🥈',
                    2 => '🥉',
                    _ => null,
                  };

                  return Card(
                    elevation: 0,
                    color: index == 0
                        ? color.primaryContainer
                        : color.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          // Medalla
                          if (medal != null)
                            Text(
                              medal,
                              style: const TextStyle(fontSize: 28),
                            )
                          else
                            Text(
                              '${index + 1}',
                              style: theme.textTheme.titleLarge,
                            ),

                          const SizedBox(width: 20),

                          // Nombre del jugador
                          Expanded(
                            child: Text(
                              player,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Puntos
                          Text(
                            '$points pts',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: index == 0
                                  ? color.onPrimaryContainer
                                  : color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Botón Nueva partida
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Nueva partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
