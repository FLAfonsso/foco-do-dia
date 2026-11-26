import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:foco_do_dia/main.dart';
import 'package:foco_do_dia/services/auth_service.dart';
import 'package:foco_do_dia/services/tarefa_service.dart';

void main() {
  final dia = DateTime(2026, 12, 1);

  // ---------------------------------------------------------------
  // TESTES DE LÓGICA: TarefaService
  // ---------------------------------------------------------------
  group('TarefaService', () {
    test('nova tarefa nasce como NÃO concluída', () {
      final s = TarefaService();
      s.adicionar(dia, 'Estudar');
      expect(s.tarefasDoDia(dia).single.concluida, isFalse);
    });

    test('não adiciona tarefa vazia', () {
      final s = TarefaService();
      s.adicionar(dia, '   ');
      expect(s.tarefasDoDia(dia), isEmpty);
    });

    test('tarefas ficam separadas por dia', () {
      final s = TarefaService();
      s.adicionar(dia, 'Tarefa do dia 1');
      s.adicionar(DateTime(2026, 12, 2), 'Tarefa do dia 2');
      expect(s.tarefasDoDia(dia).map((t) => t.titulo), ['Tarefa do dia 1']);
    });

    test('mesmo dia em horários diferentes cai na mesma lista', () {
      final s = TarefaService();
      s.adicionar(DateTime.utc(2026, 12, 1), 'A');
      s.adicionar(DateTime(2026, 12, 1, 18, 30), 'B');
      expect(s.tarefasDoDia(dia).length, 2);
    });

    test('ordem: pendentes primeiro, depois concluídas, ambas em ordem alfabética',
        () {
      final s = TarefaService();
      for (final t in [
        'Malhar',
        'comer janta',
        'Estudar Prog',
        'Arrumar quarto',
        'Ler livro',
      ]) {
        s.adicionar(dia, t);
      }
      Iterable lista() => s.tarefasDoDia(dia);
      s.alternarConcluida(lista().firstWhere((t) => t.titulo == 'Estudar Prog'));
      s.alternarConcluida(lista().firstWhere((t) => t.titulo == 'Arrumar quarto'));

      expect(lista().map((t) => t.titulo).toList(), [
        // pendentes (A-Z, sem diferenciar maiúscula/minúscula)
        'comer janta',
        'Ler livro',
        'Malhar',
        // concluídas (A-Z)
        'Arrumar quarto',
        'Estudar Prog',
      ]);
    });

    test('remover tira apenas a tarefa escolhida', () {
      final s = TarefaService();
      s.adicionar(dia, 'Fica');
      s.adicionar(dia, 'Sai');
      s.remover(s.tarefasDoDia(dia).firstWhere((t) => t.titulo == 'Sai'));
      expect(s.tarefasDoDia(dia).map((t) => t.titulo), ['Fica']);
    });

    test('marcar duas vezes volta para pendente', () {
      final s = TarefaService();
      s.adicionar(dia, 'X');
      final t = s.tarefasDoDia(dia).single;
      s.alternarConcluida(t);
      expect(t.concluida, isTrue);
      s.alternarConcluida(t);
      expect(t.concluida, isFalse);
    });

    test('pendentesNoDia conta só as pendentes', () {
      final s = TarefaService();
      s.adicionar(dia, 'A');
      s.adicionar(dia, 'B');
      s.alternarConcluida(s.tarefasDoDia(dia).first);
      expect(s.pendentesNoDia(dia), 1);
    });

    test('avisa a tela (notifyListeners) a cada mudança', () {
      final s = TarefaService();
      var avisos = 0;
      s.addListener(() => avisos++);
      s.adicionar(dia, 'A');
      final t = s.tarefasDoDia(dia).single;
      s.alternarConcluida(t);
      s.remover(t);
      expect(avisos, 3);
    });
  });

  // ---------------------------------------------------------------
  // TESTES DE LÓGICA: AuthService
  // ---------------------------------------------------------------
  group('AuthService', () {
    test('cadastro válido e login funcionam', () {
      final a = AuthService();
      expect(a.cadastrar('Pedro', 'pedro@email.com', '123456'), isNull);
      expect(a.login('PEDRO@email.com ', '123456'), isNull);
      expect(a.usuarioLogado?.nome, 'Pedro');
    });

    test('recusa e-mail repetido', () {
      final a = AuthService();
      a.cadastrar('Pedro', 'pedro@email.com', '123456');
      expect(a.cadastrar('Outro', 'Pedro@Email.com', '654321'), isNotNull);
    });

    test('recusa campos vazios, e-mail inválido e senha curta', () {
      final a = AuthService();
      expect(a.cadastrar('', 'a@b.com', '123456'), isNotNull);
      expect(a.cadastrar('Pedro', 'emailsemarroba', '123456'), isNotNull);
      expect(a.cadastrar('Pedro', 'a@b.com', '123'), isNotNull);
    });

    test('recusa senha errada e usuário inexistente', () {
      final a = AuthService();
      a.cadastrar('Pedro', 'pedro@email.com', '123456');
      expect(a.login('pedro@email.com', 'errada'), isNotNull);
      expect(a.login('naoexiste@email.com', '123456'), isNotNull);
      expect(a.usuarioLogado, isNull);
    });

    test('sair desloga o usuário', () {
      final a = AuthService();
      a.cadastrar('Pedro', 'pedro@email.com', '123456');
      a.login('pedro@email.com', '123456');
      a.sair();
      expect(a.usuarioLogado, isNull);
    });
  });

  // ---------------------------------------------------------------
  // TESTE DE PONTA A PONTA: simula um usuário usando o app
  // ---------------------------------------------------------------
  group('Fluxo completo do app', () {
    setUpAll(() async {
      await initializeDateFormatting('pt_BR', null);
    });

    testWidgets('cadastro → login → calendário → adicionar, concluir e remover',
        (tester) async {
      // Tela do tamanho de um Pixel 7
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthService()),
            ChangeNotifierProvider(create: (_) => TarefaService()),
          ],
          child: const FocoDoDiaApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1) Tela de login aparece
      expect(find.text('Login'), findsOneWidget);

      // 2) Vai para o cadastro e cria a conta
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text('Criar conta'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'), 'Pedro');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'pedro@email.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha (mín. 6 caracteres)'),
          '123456');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'), '123456');
      await tester.tap(find.text('Cadastrar'));
      await tester.pumpAndSettle();

      // 3) Volta ao login e entra
      expect(find.text('Login'), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), 'pedro@email.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), '123456');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // 4) Calendário com saudação
      expect(find.text('Olá, Pedro!'), findsOneWidget);
      await tester.tap(find.text('Ver tarefas do dia'));
      await tester.pumpAndSettle();

      // 5) Lista vazia
      expect(find.text('Nenhuma tarefa para este dia'), findsOneWidget);

      // 6) Adiciona duas tarefas pelo dialog
      Future<void> adicionar(String titulo) async {
        await tester.tap(find.text('Nova tarefa'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), titulo);
        await tester.tap(find.text('Adicionar'));
        await tester.pumpAndSettle();
      }

      await adicionar('Malhar');
      await adicionar('Estudar');
      expect(find.text('Malhar'), findsOneWidget);
      expect(find.text('Estudar'), findsOneWidget);
      expect(find.text('Pendente'), findsNWidgets(2));

      double y(String t) => tester.getTopLeft(find.text(t)).dy;
      // Ordem alfabética: Estudar acima de Malhar
      expect(y('Estudar') < y('Malhar'), isTrue);

      // 7) Conclui "Estudar" → vai para baixo de "Malhar"
      await tester.tap(find.descendant(
        of: find.widgetWithText(ListTile, 'Estudar'),
        matching: find.byType(Checkbox),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Concluída'), findsOneWidget);
      expect(y('Malhar') < y('Estudar'), isTrue);

      // 8) Remove "Malhar" pela lixeira
      await tester.tap(find.descendant(
        of: find.widgetWithText(ListTile, 'Malhar'),
        matching: find.byIcon(Icons.delete_outline_rounded),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Malhar'), findsNothing);
      expect(find.text('Estudar'), findsOneWidget);

      // Deixa o aviso (SnackBar) terminar antes de encerrar o teste
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
