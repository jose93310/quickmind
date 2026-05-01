import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/auth/login_screen.dart';
import 'package:quickmind/presentation/screens/auth/register_screen.dart';
import 'package:quickmind/presentation/screens/new_game/new_game_screen.dart';
import 'package:quickmind/storage/session_storage.dart';
import 'package:quickmind/data/repositories/auth_repository.dart';

class WelcomeScreen extends StatelessWidget {
  final AuthRepository authRepository;

  const WelcomeScreen({
    super.key,
    required this.authRepository,
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
                      await SessionStorage.saveSession(
                        userId: 'guest',
                        isGuest: true,
                      );

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewGameScreen(),
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
