import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/profile/profile_screen.dart';
import 'package:quickmind/presentation/screens/stats/stats_screen.dart';
import 'package:quickmind/presentation/screens/rounds/rounds_history_screen.dart';

import 'package:quickmind/data/repositories/stats_repository.dart';
import 'package:quickmind/data/repositories/rounds_repository.dart';
import 'package:quickmind/data/repositories/user_repository.dart';

class HomeScreen extends StatelessWidget {
  final StatsRepository statsRepository;
  final RoundsRepository roundsRepository;

  const HomeScreen({
    super.key,
    required this.statsRepository,
    required this.roundsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuickMind')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsScreen(
                      statsRepository: statsRepository,
                    ),
                  ),
                );
              },
              child: const Text('Estadísticas'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoundsHistoryScreen(
                      roundsRepository: roundsRepository,
                    ),
                  ),
                );
              },
              child: const Text('Historial de rondas'),
            ),
          ],
        ),
      ),
    );
  }
}
