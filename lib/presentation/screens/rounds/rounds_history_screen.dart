import 'package:flutter/material.dart';
import 'package:quickmind/data/db/app_database.dart';
import 'package:quickmind/data/repositories/rounds_repository.dart';

class RoundsHistoryScreen extends StatefulWidget {
  final RoundsRepository roundsRepository;

  const RoundsHistoryScreen({super.key, required this.roundsRepository});

  @override
  State<RoundsHistoryScreen> createState() => _RoundsHistoryScreenState();
}

class _RoundsHistoryScreenState extends State<RoundsHistoryScreen> {
  List<Round> rounds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRounds();
  }

  Future<void> _loadRounds() async {
    final list = await widget.roundsRepository.getHistory();
    setState(() {
      rounds = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de rondas')),
      body: rounds.isEmpty
          ? const Center(child: Text('Sin rondas aún'))
          : ListView.separated(
              itemCount: rounds.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = rounds[index];
                return ListTile(
                  title: Text('${r.category} - ${r.score} puntos'),
                  subtitle: Text(
                    'Tiempo: ${r.timeSpent}s · ${r.date}',
                  ),
                );
              },
            ),
    );
  }
}
