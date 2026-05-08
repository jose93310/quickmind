import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmind/core/theme/theme_provider.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Tema'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final currentThemeIndex = themeProvider.currentThemeIndex;
          final currentThemeData = themeProvider.themeData;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ThemeProvider.themes.length,
            itemBuilder: (context, index) {
              final theme = ThemeProvider.themes[index];
              final isSelected = index == currentThemeIndex;
              final isDark = theme.brightness == Brightness.dark;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? theme.primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => themeProvider.setTheme(index),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Círculo de muestra del color
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isDark
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF2D2D2D),
                                        Color(0xFF1A1A1A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        theme.primaryColor,
                                        theme.secondaryColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isDark ? Colors.black : theme.primaryColor)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isDark
                                ? const Icon(
                                    Icons.dark_mode,
                                    color: Color(0xFFBBDEFB),
                                    size: 24,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          // Nombre del tema
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  theme.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getTextColor(isDark, isSelected, theme, currentThemeData),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isDark ? 'Modo oscuro' : 'Modo claro',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _getSubtitleColor(isDark, currentThemeData),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Indicador de selección
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white : theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: isDark ? Colors.black : Colors.white,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getTextColor(bool isDark, bool isSelected, AppTheme theme, ThemeData currentThemeData) {
    if (isDark) return Colors.white;
    if (isSelected) return theme.primaryColor;
    return currentThemeData.colorScheme.onSurface;
  }

  Color _getSubtitleColor(bool isDark, ThemeData currentThemeData) {
    if (isDark) return Colors.grey[400]!;
    return currentThemeData.colorScheme.onSurfaceVariant;
  }
}
