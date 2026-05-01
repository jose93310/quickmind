import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmind/data/db/app_database.dart';
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
  User? user;
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

    final updated = user!.copyWith(
      avatarPath: Value(file.path),
    );

    await widget.userRepository.db
        .into(widget.userRepository.db.users)
        .insertOnConflictUpdate(
      UsersCompanion(
        id: Value(updated.id),
        email: Value(updated.email),
        nickname: Value(updated.nickname),
        name: updated.name == null
            ? const Value.absent()
            : Value(updated.name),
        country: updated.country == null
            ? const Value.absent()
            : Value(updated.country),
        city: updated.city == null
            ? const Value.absent()
            : Value(updated.city),
        birthDate: updated.birthDate == null
            ? const Value.absent()
            : Value(updated.birthDate),
        gender: updated.gender == null
            ? const Value.absent()
            : Value(updated.gender),
        avatarPath: updated.avatarPath == null
            ? const Value.absent()
            : Value(updated.avatarPath),
      ),
    );

    setState(() {
      user = updated;
    });
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
