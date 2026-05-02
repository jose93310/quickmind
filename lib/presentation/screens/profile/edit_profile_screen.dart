import 'package:flutter/material.dart';
import 'package:quickmind/data/models/auth_models.dart' as api_models;
import 'package:quickmind/data/repositories/user_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserRepository userRepository;

  const EditProfileScreen({
    super.key,
    required this.userRepository,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  api_models.User? user;
  bool isLoading = true;

  final _nameCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

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
    if (current != null) {
      _nameCtrl.text = current.name ?? '';
      _countryCtrl.text = current.country ?? '';
      _cityCtrl.text = current.city ?? '';
    }
  }

  Future<void> _save() async {
    if (user == null) return;

    try {
      await widget.userRepository.updateProfile(
        user!.id,
        name: _nameCtrl.text.isEmpty ? null : _nameCtrl.text,
        country: _countryCtrl.text.isEmpty ? null : _countryCtrl.text,
        city: _cityCtrl.text.isEmpty ? null : _cityCtrl.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar perfil')),
        body: const Center(child: Text('No hay usuario activo')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _countryCtrl,
              decoration: const InputDecoration(labelText: 'País'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'Ciudad'),
            ),
          ],
        ),
      ),
    );
  }
}
