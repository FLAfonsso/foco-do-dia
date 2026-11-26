/// Representa uma tarefa de um dia específico.
/// Toda tarefa nasce como NÃO concluída.
class Tarefa {
  final String id;
  final String titulo;
  final DateTime data;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.data,
    this.concluida = false,
  });
}
