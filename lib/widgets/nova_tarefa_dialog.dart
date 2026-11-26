import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Dialog para digitar uma nova tarefa.
/// Devolve o título digitado (ou null se o usuário cancelar).
class NovaTarefaDialog extends StatefulWidget {
  const NovaTarefaDialog({super.key});

  @override
  State<NovaTarefaDialog> createState() => _NovaTarefaDialogState();
}

class _NovaTarefaDialogState extends State<NovaTarefaDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    Navigator.pop(context, texto);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppCores.creme,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Row(
        children: [
          Icon(Icons.add_task_rounded, color: AppCores.petroleo),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Nova tarefa',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppCores.petroleoEscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Ex.: Estudar Flutter',
          prefixIcon: Icon(Icons.edit_note_rounded),
        ),
        onSubmitted: (_) => _confirmar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppCores.petroleo),
          ),
        ),
        ElevatedButton(
          onPressed: _confirmar,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppCores.amarelo,
            foregroundColor: AppCores.petroleoEscuro,
          ),
          child: const Text(
            'Adicionar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
