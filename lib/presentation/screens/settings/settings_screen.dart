import 'package:flutter/material.dart';
import 'package:quickmind/storage/theme_storage.dart';
import 'package:quickmind/storage/session_storage.dart';
import 'package:quickmind/presentation/screens/welcome/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await ThemeStorage.loadThemeMode();
    setState(() => isDarkMode = saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: isDarkMode,
            onChanged: (value) async {
              setState(() => isDarkMode = value);
              await ThemeStorage.saveThemeMode(value);
            },
          ),

          ListTile(
            title: const Text('Cerrar sesión'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await SessionStorage.clearSession();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
