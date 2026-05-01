import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/new_game/new_game_screen.dart';

class ReadyToPlayScreen extends StatelessWidget {
  const ReadyToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listo para jugar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewGameScreen()),
                  );
                },
                child: const Text('Crear partida'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Aquí irá JoinGameScreen
                },
                child: const Text('Unirse a partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
