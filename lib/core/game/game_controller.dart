import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickmind/core/utils/letter_generator.dart';


class GameController {
  static final GameController _instance = GameController._internal();
  factory GameController() => _instance;

  GameController._internal();

  final LetterGenerator _letterGen = LetterGenerator();

  String? currentLetter;
  List<String> usedLetters = [];

  /// Cargar historial desde memoria local
Future<void> load() async {
  final prefs = await SharedPreferences.getInstance();
  usedLetters = prefs.getStringList('used_letters') ?? [];
  _letterGen.restoreUsedLetters(usedLetters);
}

  /// Guardar historial en memoria local
Future<void> save() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('used_letters', usedLetters);
}

  /// Generar letra nueva sin repetir
  Future<String> nextLetter() async {
    final letter = _letterGen.nextLetter();
    currentLetter = letter;

    usedLetters = _letterGen.usedLetters;
    await save();

    return letter;
  }

  /// Reiniciar partida
  Future<void> reset() async {
    currentLetter = null;
    usedLetters.clear();
    _letterGen.reset();
    await save();
  }
}
