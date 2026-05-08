import 'package:flutter/material.dart';
import 'package:quickmind/data/services/game_service.dart';
import 'package:quickmind/data/models/game_models.dart';
import 'package:quickmind/presentation/screens/game/lobby_screen.dart';

class GameConfigScreen extends StatefulWidget {
  final GameService gameService;
  final String userId;
  final String nickname;
  
  // Parámetros para modo edición (opcionales)
  final String? editGameId;
  final String? editGameName;
  final int? editMaxPlayers;
  final int? editTotalRounds;
  final int? editTimePerRound;

  const GameConfigScreen({
    super.key,
    required this.gameService,
    required this.userId,
    required this.nickname,
    this.editGameId,
    this.editGameName,
    this.editMaxPlayers,
    this.editTotalRounds,
    this.editTimePerRound,
  });

  @override
  State<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends State<GameConfigScreen> {
  final _nameCtrl = TextEditingController();
  late int _maxPlayers;
  late int _totalRounds;
  int _timePerRound = 120;
  bool _isPublic = false;
  bool _isImmediate = true;
  ValidationType _validationType = ValidationType.voting;
  List<Category> _categories = [];
  List<int> _selectedCategoryIds = [];
  bool _isLoadingCategories = true;
  bool _isCreating = false;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool get _isEditing => widget.editGameId != null;

  @override
  void initState() {
    super.initState();
    // Inicializar con valores de edición si existen
    _maxPlayers = widget.editMaxPlayers ?? 4;
    _totalRounds = widget.editTotalRounds ?? 5;
    _timePerRound = widget.editTimePerRound ?? 120;
    if (widget.editGameName != null) {
      _nameCtrl.text = widget.editGameName!;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await widget.gameService.getCategories();
      setState(() {
        _categories = categories;
        _selectedCategoryIds = categories.take(5).map((c) => c.id).toList();
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  DateTime? _getScheduledStart() {
    if (_isImmediate || _selectedDate == null || _selectedTime == null) {
      return null;
    }
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  Future<void> _createGame() async {
    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos una categoría')),
      );
      return;
    }

    if (!_isImmediate && (_selectedDate == null || _selectedTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y hora de inicio')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final scheduledStart = _getScheduledStart();
      
      if (_isEditing) {
        // Modo edición - actualizar partida existente
        await widget.gameService.updateGameSettings(
          gameId: widget.editGameId!,
          hostId: widget.userId,
          maxPlayers: _maxPlayers,
          totalRounds: _totalRounds,
          timePerRound: _timePerRound,
          isPublic: _isPublic,
          gameName: _nameCtrl.text.trim(),
          scheduledStart: scheduledStart,
        );

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partida actualizada')),
        );
      } else {
        // Modo creación - crear nueva partida
        final game = await widget.gameService.createGame(
          hostId: widget.userId,
          maxPlayers: _maxPlayers,
          totalRounds: _totalRounds,
          timePerRound: _timePerRound,
          letterMode: LetterMode.random,
          validationType: _validationType,
          categoryIds: _selectedCategoryIds,
          isPublic: _isPublic,
          gameName: _nameCtrl.text.trim(),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LobbyScreen(
              gameService: widget.gameService,
              gameId: game.id,
              gameCode: game.code,
              userId: widget.userId,
              isHost: true,
              gameName: _nameCtrl.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar partida' : 'Configurar partida')),
      body: _isCreating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOMBRE DE PARTIDA
                  TextField(
                    controller: _nameCtrl,
                    maxLength: 15,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de partida (opcional)',
                      hintText: 'Máx. 15 caracteres',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PÚBLICA / PRIVADA
                  Card(
                    child: SwitchListTile(
                      title: const Text('Partida pública'),
                      subtitle: Text(
                        _isPublic
                            ? 'Cualquiera puede unirse desde explorar partidas'
                            : 'Solo por código de invitación',
                      ),
                      value: _isPublic,
                      onChanged: (v) => setState(() => _isPublic = v),
                      secondary: Icon(
                        _isPublic ? Icons.public : Icons.lock,
                        color: _isPublic ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // INICIO INMEDIATO / PROGRAMADO
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inicio de partida',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(
                                value: true,
                                label: Text('Inmediato'),
                                icon: Icon(Icons.play_arrow),
                              ),
                              ButtonSegment(
                                value: false,
                                label: Text('Programado'),
                                icon: Icon(Icons.schedule),
                              ),
                            ],
                            selected: {_isImmediate},
                            onSelectionChanged: (v) =>
                                setState(() => _isImmediate = v.first),
                          ),
                          if (!_isImmediate) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _pickDate,
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(
                                      _selectedDate != null
                                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                          : 'Seleccionar fecha',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _pickTime,
                                    icon: const Icon(Icons.access_time),
                                    label: Text(
                                      _selectedTime != null
                                          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                          : 'Seleccionar hora',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CANTIDAD DE JUGADORES
                  Text('Máximo de jugadores: $_maxPlayers',
                      style: theme.textTheme.titleMedium),
                  Slider(
                    value: _maxPlayers.toDouble(),
                    min: 2,
                    max: 8,
                    divisions: 6,
                    label: '$_maxPlayers jugadores',
                    onChanged: (v) =>
                        setState(() => _maxPlayers = v.round()),
                  ),
                  const SizedBox(height: 16),

                  // CANTIDAD DE RONDAS
                  Text('Rondas: $_totalRounds',
                      style: theme.textTheme.titleMedium),
                  Slider(
                    value: _totalRounds.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '$_totalRounds rondas',
                    onChanged: (v) =>
                        setState(() => _totalRounds = v.round()),
                  ),
                  const SizedBox(height: 16),

                  // TIEMPO POR RONDA
                  Text(
                      'Tiempo por ronda: ${_formatTime(_timePerRound)}',
                      style: theme.textTheme.titleMedium),
                  Slider(
                    value: _timePerRound.toDouble(),
                    min: 30,
                    max: 300,
                    divisions: 9,
                    label: _formatTime(_timePerRound),
                    onChanged: (v) =>
                        setState(() => _timePerRound = v.round()),
                  ),
                  const SizedBox(height: 24),

                  // VALIDACIÓN
                  Text('Validación',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<ValidationType>(
                    segments: const [
                      ButtonSegment(
                        value: ValidationType.ai,
                        label: Text('AI'),
                        icon: Icon(Icons.smart_toy_outlined),
                      ),
                      ButtonSegment(
                        value: ValidationType.voting,
                        label: Text('Votos'),
                        icon: Icon(Icons.how_to_vote_outlined),
                      ),
                    ],
                    selected: {_validationType},
                    onSelectionChanged: (v) =>
                        setState(() => _validationType = v.first),
                  ),
                  const SizedBox(height: 24),

                  // CATEGORÍAS
                  Text('Categorías',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_isLoadingCategories)
                    const Center(child: CircularProgressIndicator())
                  else if (_categories.isEmpty)
                    const Text('No hay categorías disponibles')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _categories.map((cat) {
                        final selected =
                            _selectedCategoryIds.contains(cat.id);
                        return FilterChip(
                          label: Text(cat.displayName),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                _selectedCategoryIds.add(cat.id);
                              } else {
                                _selectedCategoryIds.remove(cat.id);
                              }
                            });
                          },
                          avatar: cat.icon != null
                              ? Text(cat.icon!)
                              : null,
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 32),

                  // BOTÓN CREAR
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _createGame,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_isEditing ? 'Actualizar partida' : 'Crear partida'),
                      style: FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return '$seconds seg';
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return sec > 0 ? '$min min $sec seg' : '$min min';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
