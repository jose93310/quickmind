class LetterGenerator {
  // static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _letters = 'BCDFGHJKLMNPQRSTVWXYZ';


  final List<String> _available = List.from(_letters.split(''));
  final List<String> _used = [];

  /// Devuelve una letra aleatoria sin repetir
  String nextLetter() {
    if (_available.isEmpty) {
      // Reiniciar ciclo si se agotaron todas
      _available.addAll(_used);
      _used.clear();
    }

    _available.shuffle();
    final letter = _available.removeLast();
    _used.add(letter);
    return letter;
  }

  /// Devuelve las letras ya usadas
  List<String> get usedLetters => List.unmodifiable(_used);

  /// Reinicia todo
  void reset() {
    _available
      ..clear()
      ..addAll(_letters.split(''));
    _used.clear();
  }

  void restoreUsedLetters(List<String> used) {
  _used
    ..clear()
    ..addAll(used);

  _available
    ..clear()
    ..addAll(_letters.split('').where((l) => !_used.contains(l)));
}

}
