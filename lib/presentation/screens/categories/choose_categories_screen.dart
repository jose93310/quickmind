import 'package:flutter/material.dart';
import 'package:quickmind/presentation/screens/rounds/stop_round_screen.dart';

enum GameCategory {
  nombres,
  animales,
  paises,
  colores,
  comidas,
  profesiones,
  objetos,
  marcas,
}

class ChooseCategoriesScreen extends StatefulWidget {
  final String selectedLetter;
  final bool timeLimitEnabled;

  const ChooseCategoriesScreen({
    super.key,
    required this.selectedLetter,
    required this.timeLimitEnabled,
  });

  @override
  State<ChooseCategoriesScreen> createState() => _ChooseCategoriesScreenState();
}

class _ChooseCategoriesScreenState extends State<ChooseCategoriesScreen> {
  final Set<GameCategory> selected = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elige las categorías para esta partida',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Chips de categorías
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: GameCategory.values.map((category) {
                    final isSelected = selected.contains(category);

                    return FilterChip(
                      label: Text(_label(category)),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          value
                              ? selected.add(category)
                              : selected.remove(category);
                        });
                      },
                      selectedColor: color.primaryContainer,
                      checkmarkColor: color.onPrimaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? color.onPrimaryContainer
                            : color.onSurface,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Botón Start Game
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StopRoundScreen(
                            letter: widget.selectedLetter,
                            categories: selected.map(_label).toList(),
                            timeLimitEnabled: widget.timeLimitEnabled,
                          ),
                          ),
                        );
                      },
                child: const Text('Iniciar partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(GameCategory category) {
    switch (category) {
      case GameCategory.nombres:
        return 'Nombres';
      case GameCategory.animales:
        return 'Animales';
      case GameCategory.paises:
        return 'Países';
      case GameCategory.colores:
        return 'Colores';
      case GameCategory.comidas:
        return 'Comidas';
      case GameCategory.profesiones:
        return 'Profesiones';
      case GameCategory.objetos:
        return 'Objetos';
      case GameCategory.marcas:
        return 'Marcas';
    }
  }
}
