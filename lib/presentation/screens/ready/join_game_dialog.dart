import 'package:flutter/material.dart';

class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({super.key});

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unirse a Partida'),
      content: TextField(
        controller: _codeCtrl,
        decoration: const InputDecoration(
          labelText: 'Código de partida',
          hintText: 'Ej: 123456',
          prefixIcon: Icon(Icons.numbers),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _codeCtrl.text),
          child: const Text('Unirse'),
        ),
      ],
    );
  }
}
