import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Brightness brightness;

  const AppTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    this.brightness = Brightness.light,
  });
}

class ThemeProvider extends ChangeNotifier {
  static const _keyThemeIndex = 'theme_index';
  int _currentThemeIndex = 0;

  int get currentThemeIndex => _currentThemeIndex;
  AppTheme get currentTheme => themes[_currentThemeIndex];

  static final List<AppTheme> themes = [
    const AppTheme(
      name: 'Azul Océano',
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF64B5F6),
    ),
    const AppTheme(
      name: 'Verde Menta',
      primaryColor: Color(0xFF4CAF50),
      secondaryColor: Color(0xFF81C784),
    ),
    const AppTheme(
      name: 'Lavanda',
      primaryColor: Color(0xFF9C27B0),
      secondaryColor: Color(0xFFCE93D8),
    ),
    const AppTheme(
      name: 'Coral',
      primaryColor: Color(0xFFFF5722),
      secondaryColor: Color(0xFFFF8A65),
    ),
    const AppTheme(
      name: 'Dorado',
      primaryColor: Color(0xFFFFC107),
      secondaryColor: Color(0xFFFFD54F),
    ),
    const AppTheme(
      name: 'Rosa Pastel',
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFFF48FB1),
    ),
    const AppTheme(
      name: 'Turquesa',
      primaryColor: Color(0xFF009688),
      secondaryColor: Color(0xFF4DB6AC),
    ),
    const AppTheme(
      name: 'Índigo',
      primaryColor: Color(0xFF3F51B5),
      secondaryColor: Color(0xFF7986CB),
    ),
    const AppTheme(
      name: 'Ámbar',
      primaryColor: Color(0xFFFF8F00),
      secondaryColor: Color(0xFFFFB74D),
    ),
    const AppTheme(
      name: 'Cian',
      primaryColor: Color(0xFF00BCD4),
      secondaryColor: Color(0xFF4DD0E1),
    ),
    const AppTheme(
      name: 'Modo Oscuro',
      primaryColor: Color(0xFF90CAF9),
      secondaryColor: Color(0xFF64B5F6),
      brightness: Brightness.dark,
    ),
  ];

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentThemeIndex = prefs.getInt(_keyThemeIndex) ?? 0;
    notifyListeners();
  }

  Future<void> setTheme(int index) async {
    if (index >= 0 && index < themes.length) {
      _currentThemeIndex = index;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyThemeIndex, index);
      notifyListeners();
    }
  }

  ThemeData get themeData {
    final appTheme = themes[_currentThemeIndex];
    
    if (appTheme.brightness == Brightness.dark) {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: appTheme.primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: appTheme.primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: appTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
