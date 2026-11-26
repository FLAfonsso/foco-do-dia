import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../theme/app_theme.dart';

/// Um item da lista: checkbox para concluir, lixeira para remover
/// e também dá para arrastar para a esquerda para excluir.
class TarefaItem extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onAlternar;
  final VoidCallback onRemover;

  const TarefaItem({
    super.key,
    required this.tarefa,
    required this.onAlternar,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final concluida = tarefa.concluida;

    return Dismissible(
      key: ValueKey(tarefa.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemover(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppCores.vermelho,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: concluida ? const Color(0xFFE8F1F4) : AppCores.branco,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Checkbox(
            value: concluida,
            onChanged: (_) => onAlternar(),
            activeColor: AppCores.petroleo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          title: Text(
            tarefa.titulo,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: concluida ? Colors.black45 : AppCores.petroleoEscuro,
              decoration: concluida ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: concluida ? AppCores.petroleo : AppCores.amarelo,
              ),
              const SizedBox(width: 6),
              Text(concluida ? 'Concluída' : 'Pendente'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppCores.vermelho,
            tooltip: 'Remover',
            onPressed: onRemover,
          ),
        ),
      ),
    );
  }
}
