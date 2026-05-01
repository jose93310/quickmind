import 'package:flutter/material.dart';
import 'package:quickmind/core/game/game_controller.dart';
import 'package:quickmind/core/utils/letter_generator.dart';
import 'package:quickmind/presentation/screens/categories/choose_categories_screen.dart';
import 'package:quickmind/presentation/screens/history/round_history_screen.dart';
import 'package:quickmind/presentation/screens/settings/settings_screen.dart';

enum ValidationType { ai, voting, mixed, manual }
enum GameLanguage { es, en }
enum LetterMode { random, manual }


class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  ValidationType validationType = ValidationType.ai;
  GameLanguage language = GameLanguage.es;
  bool timeLimitEnabled = true;
  LetterMode letterMode = LetterMode.random;
  String manualLetter = '';

  final letterGen = LetterGenerator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear partida')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VALIDACIÓN
            Text(
              'Validación',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SegmentedButton<ValidationType>(
              segments: const [
                ButtonSegment(
                  value: ValidationType.ai,
                  label: Text('AI'),
                  icon: Icon(Icons.smart_toy_outlined),
                ),
                ButtonSegment(
                  value: ValidationType.voting,
                  label: Text('Voting'),
                  icon: Icon(Icons.how_to_vote_outlined),
                ),
                ButtonSegment(
                  value: ValidationType.mixed,
                  label: Text('Mixed'),
                  icon: Icon(Icons.merge_type_outlined),
                ),
                ButtonSegment(
                  value: ValidationType.manual,
                  label: Text('Manual'),
                  icon: Icon(Icons.edit_note_outlined),
                ),
              ],
              selected: {validationType},
              onSelectionChanged: (value) {
                setState(() => validationType = value.first);
              },
            ),

            const SizedBox(height: 32),

            // IDIOMA
            Text(
              'Idioma',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 32),

            // TIPO DE LETRA
            Text(
              'Letra de la partida',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SegmentedButton<LetterMode>(
              segments: const [
                ButtonSegment(
                  value: LetterMode.random,
                  label: Text('Aleatoria'),
                  icon: Icon(Icons.shuffle),
                ),
                ButtonSegment(
                  value: LetterMode.manual,
                  label: Text('Manual'),
                  icon: Icon(Icons.edit),
                ),
              ],
              selected: {letterMode},
              onSelectionChanged: (value) {
                setState(() => letterMode = value.first);
              },
            ),

            const SizedBox(height: 16),

            // CAMPO PARA LETRA MANUAL
            if (letterMode == LetterMode.manual)
              TextField(
                maxLength: 1,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Letra',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    manualLetter = value.toUpperCase();
                  });
                },
              ),

            const SizedBox(height: 12),

            DropdownMenu<GameLanguage>(
              initialSelection: language,
              onSelected: (value) {
                if (value != null) {
                  setState(() => language = value);
                }
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: GameLanguage.es,
                  label: 'Español',
                ),
                DropdownMenuEntry(
                  value: GameLanguage.en,
                  label: 'English',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // TIEMPO LÍMITE
            SwitchListTile.adaptive(
              title: const Text('Tiempo límite'),
              value: timeLimitEnabled,
              onChanged: (value) => setState(() => timeLimitEnabled = value),
            ),

            const Spacer(),

            // BOTÓN NEXT
            SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final game = GameController();

                // Cargar estado previo desde memoria local
                await game.load();

                // Validación si es manual
                if (letterMode == LetterMode.manual) {
                  if (manualLetter.isEmpty || manualLetter.length != 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Introduce una letra válida')),
                    );
                    return;
                  }
                }

                // Generar o usar letra manual
                final letter = letterMode == LetterMode.random
                    ? await game.nextLetter()
                    : manualLetter;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChooseCategoriesScreen(
                      selectedLetter: letter,
                      timeLimitEnabled: timeLimitEnabled,
                    ),
                  ),
                );
              },
              child: const Text('Siguiente'),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoundHistoryScreen()),
              );
            },
            child: const Text('Historial de Rondas'),
          ),
        ),
        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            child: const Text('Configuración'),
          ),
        ),



          ],
        ),
      ),
    );
  }
}
