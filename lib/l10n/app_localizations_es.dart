// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'QuickMind';

  @override
  String get welcomeTitle => '¡Bienvenido a Stop!';

  @override
  String get welcomeSubtitle => 'Desafía a tus amigos en un juego rápido de palabras.';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get playAsGuest => 'Jugar como invitado';
}
