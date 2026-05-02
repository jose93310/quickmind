import 'package:flutter/material.dart';
import '../../../data/services/game_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../screens/ready/ready_to_play_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../../../storage/session_storage.dart';

class WelcomeScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final GameService gameService;

  const WelcomeScreen({
    super.key,
    required this.authRepository,
    required this.gameService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'QuickMind',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),

                const SizedBox(height: 40),

                // JUGAR COMO INVITADO
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      // Crear ID de invitado único
                      final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
                      final guestNickname = 'Invitado${guestId.substring(guestId.length - 4)}';
                      
                      await SessionStorage.saveSession(
                        userId: guestId,
                        isGuest: true,
                      );

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReadyToPlayScreen(
                            gameService: gameService,
                            userId: guestId,
                            nickname: guestNickname,
                          ),
                        ),
                      );
                    },
                    child: const Text('Jugar como invitado'),
                  ),
                ),

                const SizedBox(height: 16),

                // INICIAR SESIÓN
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(
                            authRepository: authRepository,
                            onLoggedIn: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                ),

                const SizedBox(height: 16),

                // REGISTRARSE
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          authRepository: authRepository,
                          onRegistered: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
