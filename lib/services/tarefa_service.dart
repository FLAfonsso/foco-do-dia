import 'package:flutter/foundation.dart';

import '../models/tarefa.dart';

/// Guarda as tarefas separadas por dia e avisa as telas quando algo muda.
class TarefaService extends ChangeNotifier {
  // Chave = data no formato "2026-11-23"; valor = tarefas daquele dia.
  final Map<String, List<Tarefa>> _tarefasPorDia = {};

  // Contador para gerar um id único para cada tarefa.
  int _proximoId = 0;

  String _chave(DateTime dia) {
    final mes = dia.month.toString().padLeft(2, '0');
    final d = dia.day.toString().padLeft(2, '0');
    return '${dia.year}-$mes-$d';
  }

  /// Tarefas do dia já ordenadas:
  /// pendentes primeiro, depois concluídas, ambas em ordem alfabética.
  List<Tarefa> tarefasDoDia(DateTime dia) {
    final lista = List<Tarefa>.from(_tarefasPorDia[_chave(dia)] ?? []);

    lista.sort((a, b) {
      if (a.concluida != b.concluida) {
        return a.concluida ? 1 : -1; // pendente vem antes
      }
      return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
    });

    return lista;
  }

  int pendentesNoDia(DateTime dia) {
    return (_tarefasPorDia[_chave(dia)] ?? [])
        .where((t) => !t.concluida)
        .length;
  }

  void adicionar(DateTime dia, String titulo) {
    final texto = titulo.trim();
    if (texto.isEmpty) return;

    _tarefasPorDia.putIfAbsent(_chave(dia), () => []).add(
          Tarefa(
            id: (_proximoId++).toString(),
            titulo: texto,
            data: dia,
          ),
        );
    notifyListeners();
  }

  void remover(Tarefa tarefa) {
    _tarefasPorDia[_chave(tarefa.data)]?.removeWhere((t) => t.id == tarefa.id);
    notifyListeners();
  }

  void alternarConcluida(Tarefa tarefa) {
    tarefa.concluida = !tarefa.concluida;
    notifyListeners();
  }
}
