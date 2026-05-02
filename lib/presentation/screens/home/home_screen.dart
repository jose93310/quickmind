import 'package:flutter/material.dart';
import '../../../data/services/game_service.dart';
import '../../../data/repositories/stats_repository.dart';
import '../../../data/repositories/rounds_repository.dart';
import '../../../storage/session_storage.dart';
import '../stats/stats_screen.dart';
import '../rounds/rounds_history_screen.dart';
import '../ready/ready_to_play_screen.dart';

class HomeScreen extends StatefulWidget {
  final StatsRepository statsRepository;
  final RoundsRepository roundsRepository;
  final GameService gameService;

  const HomeScreen({
    super.key,
    required this.statsRepository,
    required this.roundsRepository,
    required this.gameService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  String? nickname;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final id = await SessionStorage.getUserId();
    // Por simplicidad, usamos el ID como nickname si no hay otro
    setState(() {
      userId = id ?? 'unknown';
      nickname = id?.startsWith('guest_') == true 
          ? 'Invitado' 
          : id ?? 'Usuario';
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
      appBar: AppBar(
        title: const Text('QuickMind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Perfil resumen
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(nickname ?? 'Usuario'),
                subtitle: userId?.startsWith('guest_') == true 
                    ? const Text('Modo invitado') 
                    : null,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botón principal - JUGAR
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadyToPlayScreen(
                      gameService: widget.gameService,
                      userId: userId!,
                      nickname: nickname!,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('JUGAR'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Estadísticas
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsScreen(
                      statsRepository: widget.statsRepository,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('Estadísticas'),
            ),
            
            const SizedBox(height: 16),
            
            // Historial
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoundsHistoryScreen(
                      roundsRepository: widget.roundsRepository,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Historial de rondas'),
            ),
          ],
        ),
      ),
    );
  }
}
