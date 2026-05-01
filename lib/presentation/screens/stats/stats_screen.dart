import 'package:flutter/material.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/data/repositories/stats_repository.dart';

class StatsScreen extends StatefulWidget {
  final StatsRepository statsRepository;

  const StatsScreen({super.key, required this.statsRepository});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  UserStat? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final s = await widget.statsRepository.getCurrentStats();
    setState(() {
      stats = s;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estadísticas')),
        body: const Center(child: Text('Sin estadísticas aún')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _StatTile(
              label: 'Partidas jugadas',
              value: stats!.gamesPlayed.toString(),
            ),
            _StatTile(
              label: 'Rondas jugadas',
              value: stats!.roundsPlayed.toString(),
            ),
            _StatTile(
              label: 'Respuestas correctas',
              value: stats!.validAnswers.toString(),
            ),
            _StatTile(
              label: 'Respuestas incorrectas',
              value: stats!.invalidAnswers.toString(),
            ),
            _StatTile(
              label: 'Mejor puntuación',
              value: stats!.bestScore.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}
