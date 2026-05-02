import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'presentation/screens/welcome/welcome_screen.dart';
import 'presentation/screens/home/home_screen.dart';

import 'core/constants/api_constants.dart';
import 'data/db/app_database.dart';
import 'data/api/api_client.dart';
import 'data/api/auth_api.dart';
import 'data/api/game_api.dart';
import 'data/api/stats_api.dart';
import 'data/api/rounds_api.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'data/repositories/rounds_repository.dart';
import 'data/services/game_hub_service.dart';
import 'data/services/game_service.dart';
import 'data/db/daos/stats_dao.dart';
import 'data/db/daos/rounds_dao.dart';

import 'storage/theme_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Base de datos local
  final db = AppDatabase();

  // Cliente HTTP configurado
  final apiClient = ApiClient(ApiConstants.baseUrl);
  final dio = apiClient.client;
  
  // Configurar timeouts y opciones
  dio.options.connectTimeout = ApiConstants.timeout;
  dio.options.receiveTimeout = ApiConstants.timeout;

  // APIs
  final authApi = AuthApi(dio);
  final gameApi = GameApi(dio);
  final statsApi = StatsApi();
  final roundsApi = RoundsApi();

  // Repositories
  final authRepository = AuthRepository(api: authApi, db: db);
  final statsRepository = StatsRepository(dao: StatsDao(db), api: statsApi);
  final roundsRepository = RoundsRepository(dao: RoundsDao(db), api: roundsApi);

  // SignalR + GameService
  final hubService = GameHubService();
  final gameService = GameService(
    gameApi: gameApi,
    hubService: hubService,
  );

  runApp(
    QuickMindApp(
      authRepository: authRepository,
      statsRepository: statsRepository,
      roundsRepository: roundsRepository,
      gameService: gameService,
    ),
  );
}

class QuickMindApp extends StatefulWidget {
  final AuthRepository authRepository;
  final StatsRepository statsRepository;
  final RoundsRepository roundsRepository;
  final GameService gameService;

  const QuickMindApp({
    super.key,
    required this.authRepository,
    required this.statsRepository,
    required this.roundsRepository,
    required this.gameService,
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
  void dispose() {
    widget.gameService.dispose();
    super.dispose();
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

      home: WelcomeScreen(
        authRepository: widget.authRepository,
        gameService: widget.gameService,
      ),

      routes: {
        '/home': (_) => HomeScreen(
              statsRepository: widget.statsRepository,
              roundsRepository: widget.roundsRepository,
              gameService: widget.gameService,
            ),
      },
    );
  }
}
