import 'package:flutter/material.dart';
import 'package:quickmind/data/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final VoidCallback onRegistered;

  const RegisterScreen({
    super.key,
    required this.authRepository,
    required this.onRegistered,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool isLoading = false;
  String? error;

  Future<void> _register() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      await widget.authRepository.register(
        email: _emailCtrl.text.trim(),
        nickname: _nickCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      widget.onRegistered();
    } catch (e) {
      setState(() {
        error = 'Error al registrar';
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _nickCtrl,
              decoration: const InputDecoration(labelText: 'Nickname'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
