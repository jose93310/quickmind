import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmind/data/models/auth_models.dart' as api_models;
import 'package:quickmind/data/repositories/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository userRepository;

  const ProfileScreen({
    super.key,
    required this.userRepository,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  api_models.User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final current = await widget.userRepository.getCurrentUser();
    setState(() {
      user = current;
      isLoading = false;
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null || user == null) return;

    // Actualizar avatar mediante el repositorio
    try {
      final updated = await widget.userRepository.updateProfile(
        user!.id,
        name: user!.name,
        country: user!.country,
        city: user!.city,
      );
      
      setState(() {
        user = updated;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(child: Text('No hay usuario activo')),
      );
    }

    final String initial = user!.nickname.isNotEmpty
        ? user!.nickname[0].toUpperCase()
        : user!.email[0].toUpperCase();

    final Widget avatar = user!.avatarPath != null
        ? CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(File(user!.avatarPath!)),
          )
        : CircleAvatar(
            radius: 40,
            child: Text(
              initial,
              style: theme.textTheme.headlineMedium,
            ),
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAvatar,
              child: avatar,
            ),
            const SizedBox(height: 16),
            Text(
              user!.nickname,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(user!.email),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Estadísticas (luego las llenamos)',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
