// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuickMind';

  @override
  String get welcomeTitle => 'Welcome to Stop!';

  @override
  String get welcomeSubtitle => 'Challenge your friends in a fast-paced word game.';

  @override
  String get login => 'Log In';

  @override
  String get playAsGuest => 'Play as Guest';
}
