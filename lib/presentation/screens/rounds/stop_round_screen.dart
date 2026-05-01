import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quickmind/core/game/game_controller.dart';
import 'package:quickmind/presentation/screens/history/round_history_screen.dart';
import 'package:quickmind/presentation/screens/voting/voting_screen.dart';

class StopRoundScreen extends StatefulWidget {
  final String letter;
  final List<String> categories;
  final bool timeLimitEnabled;

  const StopRoundScreen({
    super.key,
    required this.letter,
    required this.categories,
    required this.timeLimitEnabled,
  });

  @override
  State<StopRoundScreen> createState() => _StopRoundScreenState();
}

class _StopRoundScreenState extends State<StopRoundScreen>
    with TickerProviderStateMixin {

  late Map<String, TextEditingController> controllers;
  int timeLeft = 60;
  Timer? timer;

  // Animación de la letra
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  // Animación premium del botón STOP
  late AnimationController _stopController;
  late Animation<double> _stopScale;

  // GameController
  final game = GameController();
  List<String> usedLetters = [];

  @override
  void initState() {
    super.initState();

    controllers = {
      for (final c in widget.categories) c: TextEditingController(),
    };

    _loadGameState();

    if (widget.timeLimitEnabled) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (timeLeft == 0) {
          t.cancel();
          _finishRound();
        } else {
          setState(() => timeLeft--);
        }
      });
    }

    // Animación de la letra
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Animación premium del botón STOP
    _stopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _stopScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _stopController,
        curve: Curves.easeInOut,
      ),
    );

    _stopController.repeat(reverse: true);
  }

  Future<void> _loadGameState() async {
    await game.load();
    setState(() {
      usedLetters = game.usedLetters;
    });
  }

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    timer?.cancel();
    _controller.dispose();
    _stopController.dispose();
    super.dispose();
  }

  void _finishRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(
          playerName: 'Jugador 1',
          answers: {
            for (final c in widget.categories)
              c: controllers[c]!.text,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ronda'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RoundHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // LETRA ANIMADA
            ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _opacity,
                child: Text(
                  widget.letter,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                    fontSize: 120,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // HISTORIAL DE LETRAS
            if (usedLetters.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Letras usadas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: usedLetters.map((l) {
                      return Chip(
                        label: Text(
                          l,
                          style: theme.textTheme.titleMedium,
                        ),
                        backgroundColor: color.surfaceContainerHighest,
                      );
                    }).toList(),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // TIMER
            if (widget.timeLimitEnabled)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: timeLeft / 60),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: value,
                          strokeWidth: 8,
                          color: color.primary,
                        ),
                        Text(
                          '$timeLeft',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // CAMPOS DE CATEGORÍAS
            Expanded(
              child: ListView.separated(
                itemCount: widget.categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final category = widget.categories[index];
                  return TextField(
                    controller: controllers[category],
                    decoration: InputDecoration(
                      labelText: category,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // BOTÓN STOP ANIMADO
            ScaleTransition(
              scale: _stopScale,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _finishRound,
                  child: const Text('STOP'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
