import 'package:flutter/material.dart';
import 'package:quickmind/storage/session_storage.dart';

class LoggedOutScreen extends StatelessWidget {
  const LoggedOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sesión cerrada'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await SessionStorage.clearSession();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
