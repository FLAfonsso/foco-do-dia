import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/auth_service.dart';
import '../services/tarefa_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_principal.dart';
import 'login_screen.dart';
import 'tarefas_screen.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _diaFocado = DateTime.now();
  DateTime _diaSelecionado = DateTime.now();

  void _sair() {
    context.read<AuthService>().sair();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthService>().usuarioLogado;
    final tarefas = context.watch<TarefaService>();
    final pendentes = tarefas.pendentesNoDia(_diaSelecionado);
    final dataFormatada =
        DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(_diaSelecionado);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Saudação
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${usuario?.nome ?? 'visitante'}!',
                          style: const TextStyle(
                            color: AppCores.amarelo,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Escolha um dia para planejar',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    icon: const Icon(Icons.logout_rounded,
                        color: AppCores.branco),
                    onPressed: _sair,
                  ),
                ],
              ),
            ),

            // Calendário
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppCores.creme,
                borderRadius: BorderRadius.circular(28),
              ),
              child: TableCalendar(
                locale: 'pt_BR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _diaFocado,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                selectedDayPredicate: (dia) => isSameDay(dia, _diaSelecionado),
                onDaySelected: (selecionado, focado) {
                  setState(() {
                    _diaSelecionado = selecionado;
                    _diaFocado = focado;
                  });
                },
                onPageChanged: (focado) => _diaFocado = focado,
                // Mostra um pontinho nos dias que têm tarefas
                eventLoader: (dia) => tarefas.tarefasDoDia(dia),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppCores.petroleoEscuro,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded,
                      color: AppCores.petroleo),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded,
                      color: AppCores.petroleo),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppCores.petroleoClaro,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: AppCores.petroleoEscuro,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppCores.amarelo,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: AppCores.petroleoEscuro,
                    fontWeight: FontWeight.w900,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppCores.petroleo,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: AppCores.vermelho),
                ),
              ),
            ),

            // Resumo do dia selecionado
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppCores.petroleo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available_rounded,
                      color: AppCores.amarelo, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataFormatada,
                          style: const TextStyle(
                            color: AppCores.branco,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pendentes == 0
                              ? 'Nenhuma tarefa pendente'
                              : '$pendentes tarefa(s) pendente(s)',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: BotaoPrincipal(
                texto: 'Ver tarefas do dia',
                icone: Icons.checklist_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TarefasScreen(dia: _diaSelecionado),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
