import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmind/core/theme/theme_provider.dart';
import 'package:quickmind/data/api/auth_api.dart';
import 'package:quickmind/storage/session_storage.dart';
import 'package:quickmind/presentation/screens/settings/logged_out_screen.dart';
import 'package:quickmind/presentation/screens/settings/theme_selector_screen.dart';
import 'package:quickmind/presentation/screens/profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AuthApi? authApi;

  const SettingsScreen({super.key, this.authApi});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          // SECCIÓN DE APARIENCIA
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Apariencia',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // SELECTOR DE TEMA
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: currentTheme.brightness == Brightness.dark
                    ? const LinearGradient(
                        colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [currentTheme.primaryColor, currentTheme.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: currentTheme.brightness == Brightness.dark
                  ? const Icon(Icons.dark_mode, color: Color(0xFFBBDEFB), size: 20)
                  : null,
            ),
            title: const Text('Tema de colores'),
            subtitle: Text(currentTheme.name),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThemeSelectorScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          // SECCIÓN DE CUENTA
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Cuenta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // EDITAR PERFIL
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Editar perfil'),
            subtitle: const Text('Nombre, nickname, avatar'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (authApi != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(authApi: authApi!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No disponible para invitados')),
                );
              }
            },
          ),
          
          const Divider(),
          
          // SECCIÓN DE SESIÓN
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Sesión',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // CERRAR SESIÓN
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await SessionStorage.clearSession();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoggedOutScreen()),
                    (_) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
