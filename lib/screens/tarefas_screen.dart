import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/tarefa.dart';
import '../services/tarefa_service.dart';
import '../theme/app_theme.dart';
import '../widgets/nova_tarefa_dialog.dart';
import '../widgets/tarefa_item.dart';

class TarefasScreen extends StatelessWidget {
  final DateTime dia;

  const TarefasScreen({super.key, required this.dia});

  Future<void> _abrirDialog(BuildContext context, TarefaService service) async {
    final titulo = await showDialog<String>(
      context: context,
      builder: (_) => const NovaTarefaDialog(),
    );
    if (titulo != null) {
      service.adicionar(dia, titulo);
    }
  }

  void _remover(BuildContext context, TarefaService service, Tarefa tarefa) {
    service.remover(tarefa);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${tarefa.titulo}" removida'),
        backgroundColor: AppCores.petroleo,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TarefaService>();
    final tarefas = service.tarefasDoDia(dia);
    final concluidas = tarefas.where((t) => t.concluida).length;
    final pendentes = tarefas.length - concluidas;
    final progresso = tarefas.isEmpty ? 0.0 : concluidas / tarefas.length;

    final diaSemana = DateFormat('EEEE', 'pt_BR').format(dia);
    final diaSemanaMaiusculo =
        diaSemana[0].toUpperCase() + diaSemana.substring(1);
    final data = DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(dia);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppCores.branco,
        elevation: 0,
        title: const Text('Minhas tarefas'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppCores.amarelo,
        foregroundColor: AppCores.petroleoEscuro,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _abrirDialog(context, service),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com data e progresso
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diaSemanaMaiusculo,
                  style: const TextStyle(
                    color: AppCores.amarelo,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(data, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _contador(Icons.pending_actions_rounded, '$pendentes',
                        'pendentes'),
                    const SizedBox(width: 12),
                    _contador(Icons.task_alt_rounded, '$concluidas',
                        'concluídas'),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 10,
                    backgroundColor: AppCores.petroleo,
                    valueColor:
                        const AlwaysStoppedAnimation(AppCores.amarelo),
                  ),
                ),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppCores.creme,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: tarefas.isEmpty
                  ? _listaVazia()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                      itemCount: tarefas.length,
                      itemBuilder: (context, i) {
                        final tarefa = tarefas[i];
                        return TarefaItem(
                          tarefa: tarefa,
                          onAlternar: () => service.alternarConcluida(tarefa),
                          onRemover: () => _remover(context, service, tarefa),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contador(IconData icone, String numero, String rotulo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppCores.petroleo,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icone, color: AppCores.amarelo),
            const SizedBox(width: 8),
            Text(
              numero,
              style: const TextStyle(
                color: AppCores.branco,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            // Flexible: o rótulo encolhe em telas estreitas em vez de estourar
            Flexible(
              child: Text(
                rotulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaVazia() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wb_sunny_rounded, size: 64, color: AppCores.amarelo),
          SizedBox(height: 12),
          Text(
            'Nenhuma tarefa para este dia',
            style: TextStyle(
              color: AppCores.petroleoEscuro,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Toque em "Nova tarefa" para começar',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
