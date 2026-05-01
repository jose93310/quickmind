import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/results/final_scores_screen.dart';

class RoundResultsScreen extends StatelessWidget {
  final String playerName;
  final Map<String, String> answers; // categoría -> respuesta
  final Map<String, bool> votes;     // categoría -> válida/inválida

  const RoundResultsScreen({
    super.key,
    required this.playerName,
    required this.answers,
    required this.votes,
  });

  int _calculatePoints() {
    int total = 0;
    for (final entry in votes.entries) {
      if (entry.value) total += 10; // 10 puntos por respuesta válida
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final totalPoints = _calculatePoints();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de la ronda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Jugador: $playerName',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Lista de resultados
            Expanded(
              child: ListView.separated(
                itemCount: answers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = answers.keys.elementAt(index);
                  final answer = answers[category];
                  final isValid = votes[category] ?? false;

                  return Card(
                    elevation: 0,
                    color: color.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Categoría + respuesta
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (answer?.isEmpty ?? true)
                                      ? '(Sin respuesta)'
                                      : answer!,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Estado
                          Icon(
                            isValid
                                ? Icons.check_circle
                                : Icons.cancel_rounded,
                            color: isValid
                                ? color.primary
                                : color.error,
                            size: 32,
                          ),

                          const SizedBox(width: 12),

                          // Puntos
                          Text(
                            isValid ? '+10' : '+0',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isValid
                                  ? color.primary
                                  : color.error,
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

            // Total de puntos
            Center(
              child: Text(
                'Total: $totalPoints puntos',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botón continuar
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Se navega a FinalScoresScreen o siguiente ronda
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FinalScoresScreen(
                      scores: {
                        'Jugador 1': 80,
                        'Jugador 2': 60,
                        'Jugador 3': 40,
                      },
                    ),
                  ),
                );
                },
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
