import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  
  bool isLoading = false;
  String? error;
  bool _obscurePassword = true;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email es requerido';
    }
    final email = value.trim();
    if (email.contains(' ')) {
      return 'Email no puede contener espacios';
    }
    if (email.length > 60) {
      return 'Email no puede tener más de 60 caracteres';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Formato de email no válido';
    }
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nickname es requerido';
    }
    final nick = value.trim();
    if (nick.contains(' ')) {
      return 'Nickname no puede contener espacios';
    }
    if (nick.length < 3) {
      return 'Nickname debe tener al menos 3 caracteres';
    }
    if (nick.length > 30) {
      return 'Nickname no puede tener más de 30 caracteres';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contraseña es requerida';
    }
    if (value.contains(' ')) {
      return 'Contraseña no puede contener espacios';
    }
    if (value.length < 4) {
      return 'Contraseña debe tener al menos 4 caracteres';
    }
    if (value.length > 15) {
      return 'Contraseña no puede tener más de 15 caracteres';
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        error = e.toString().replaceFirst('Exception: ', '');
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'ejemplo@correo.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                maxLength: 60,
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nickCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'Tu nombre de usuario',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                textInputAction: TextInputAction.next,
                maxLength: 30,
                validator: _validateNickname,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: '4-15 caracteres',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                maxLength: 15,
                validator: _validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
              ),
              const SizedBox(height: 24),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              FilledButton(
                onPressed: isLoading ? null : _register,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nickCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}
