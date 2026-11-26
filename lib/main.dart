import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/tarefa_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega os nomes de meses e dias em português
  await initializeDateFormatting('pt_BR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TarefaService()),
      ],
      child: const FocoDoDiaApp(),
    ),
  );
}

class FocoDoDiaApp extends StatelessWidget {
  const FocoDoDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foco do Dia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const LoginScreen(),
    );
  }
}
