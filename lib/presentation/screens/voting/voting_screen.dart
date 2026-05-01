import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/results/round_results_screen.dart';

class VotingScreen extends StatefulWidget {
  final String playerName;
  final Map<String, String> answers; // categoría -> respuesta

  const VotingScreen({
    super.key,
    required this.playerName,
    required this.answers,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late final List<String> categories;
  int index = 0;
  final Map<String, bool> votes = {};

  @override
  void initState() {
    super.initState();
    categories = widget.answers.keys.toList();
  }

  void _vote(bool isValid) {
    final category = categories[index];
    votes[category] = isValid;

    if (index < categories.length - 1) {
      setState(() => index++);
    } else {
      _finishVoting();
    }
  }

  void _finishVoting() {
      // navegas a RoundResultsScreen
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoundResultsScreen(
          playerName: widget.playerName,
          answers: widget.answers,
          votes: votes,
        ),
      ),
    );    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final category = categories[index];
    final answer = widget.answers[category];

    return PopScope(
    canPop: false, 
    onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Votando: ${widget.playerName}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Categoría
            Text(
              category,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Respuesta del jugador
            Card(
              elevation: 0,
              color: color.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  (answer?.isEmpty ?? true) ? '(Sin respuesta)' : answer!,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Botones de voto
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: color.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _vote(true),
                    child: const Text('Válida'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _vote(false),
                    child: const Text('Inválida'),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Indicador de progreso
            Text(
              'Categoría ${index + 1} de ${categories.length}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
