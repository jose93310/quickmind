import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmind/data/api/auth_api.dart';
import 'package:quickmind/data/models/auth_models.dart';
import 'package:quickmind/data/models/location_data.dart';
import 'package:quickmind/storage/session_storage.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final AuthApi authApi;

  const EditProfileScreen({
    super.key,
    required this.authApi,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  User? _user;
  File? _avatarFile;

  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedGender;
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = await SessionStorage.getUserId();
      if (userId == null) {
        setState(() {
          _error = 'No hay sesión activa';
          _isLoading = false;
        });
        return;
      }

      final user = await widget.authApi.getProfile(userId);
      setState(() {
        _user = user;
        _nameCtrl.text = user.name ?? '';
        _nicknameCtrl.text = user.nickname;
        _selectedCountry = user.country;
        _selectedCity = user.city;
        _selectedGender = user.gender;
        
        if (_selectedCountry != null) {
          _availableCities = LocationData.getCities(_selectedCountry!);
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await widget.authApi.updateProfile(
        _user!.id,
        name: _nameCtrl.text.trim(),
        country: _selectedCountry,
        city: _selectedCity,
      );

      // Update nickname in session storage
      await SessionStorage.saveSession(
        userId: _user!.id,
        isGuest: false,
        nickname: _nicknameCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // AVATAR
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              backgroundImage: _avatarFile != null
                                  ? FileImage(_avatarFile!)
                                  : null,
                              child: _avatarFile == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para cambiar foto',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // NOMBRE
                      TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Tu nombre completo',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // NICKNAME
                      TextField(
                        controller: _nicknameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nickname',
                          hintText: 'Tu nombre de usuario',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // SEXO
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Sexo',
                          prefixIcon: Icon(Icons.wc),
                        ),
                        items: LocationData.genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // PAÍS
                      DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'País',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        items: LocationData.countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                            _selectedCity = null;
                            _availableCities = value != null
                                ? LocationData.getCities(value)
                                : [];
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // CIUDAD
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: _availableCities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: _selectedCountry != null
                            ? (value) {
                                setState(() => _selectedCity = value);
                              }
                            : null,
                      ),
                      const SizedBox(height: 32),

                      // BOTÓN GUARDAR
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : _saveProfile,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                              _isSaving ? 'Guardando...' : 'Guardar cambios'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nicknameCtrl.dispose();
    super.dispose();
  }
}
