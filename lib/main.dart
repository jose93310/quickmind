import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'presentation/screens/welcome/welcome_screen.dart';
import 'presentation/screens/home/home_screen.dart';

import 'data/db/app_database.dart';
import 'data/api/user_api.dart';
import 'data/api/stats_api.dart';
import 'data/api/rounds_api.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'data/repositories/rounds_repository.dart';
import 'data/db/daos/user_dao.dart';
import 'data/db/daos/stats_dao.dart';
import 'data/db/daos/rounds_dao.dart';

import 'storage/theme_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  final userApi = UserApi();
  final statsApi = StatsApi();
  final roundsApi = RoundsApi();

  final authRepository = AuthRepository(api: userApi, db: db);
  final statsRepository = StatsRepository(dao: StatsDao(db), api: statsApi);
  final roundsRepository = RoundsRepository(dao: RoundsDao(db), api: roundsApi);

  runApp(
    QuickMindApp(
      authRepository: authRepository,
      statsRepository: statsRepository,
      roundsRepository: roundsRepository,
    ),
  );
}

class QuickMindApp extends StatefulWidget {
  final AuthRepository authRepository;
  final StatsRepository statsRepository;
  final RoundsRepository roundsRepository;

  const QuickMindApp({
    super.key,
    required this.authRepository,
    required this.statsRepository,
    required this.roundsRepository,
  });

  @override
  State<QuickMindApp> createState() => _QuickMindAppState();
}

class _QuickMindAppState extends State<QuickMindApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeStorage.loadThemeMode();
    setState(() => isDarkMode = savedTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: WelcomeScreen(authRepository: widget.authRepository),

      routes: {
        '/home': (_) => HomeScreen(
              statsRepository: widget.statsRepository,
              roundsRepository: widget.roundsRepository,
            ),
      },
    );
  }
}
