import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_principal.dart';
import '../widgets/cabecalho_auth.dart';
import 'cadastro_screen.dart';
import 'calendario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    final erro =
        context.read<AuthService>().login(_emailCtrl.text, _senhaCtrl.text);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: AppCores.vermelho),
      );
      return;
    }

    // Fecha avisos antigos (ex.: "Cadastro realizado") antes de trocar de tela
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CalendarioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CabecalhoAuth(
              titulo: 'Foco do Dia',
              subtitulo: 'Entre para organizar suas tarefas',
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppCores.creme,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppCores.petroleoEscuro,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe seu e-mail'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaCtrl,
                          obscureText: _ocultarSenha,
                          decoration: InputDecoration(
                            hintText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_ocultarSenha
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                              onPressed: () =>
                                  setState(() => _ocultarSenha = !_ocultarSenha),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Informe sua senha'
                              : null,
                          onFieldSubmitted: (_) => _entrar(),
                        ),
                        const SizedBox(height: 28),
                        BotaoPrincipal(
                          texto: 'Entrar',
                          icone: Icons.login_rounded,
                          onPressed: _entrar,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CadastroScreen(),
                              ),
                            ),
                            child: const Text.rich(
                              TextSpan(
                                text: 'Ainda não tem conta? ',
                                style: TextStyle(color: Colors.black54),
                                children: [
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: TextStyle(
                                      color: AppCores.petroleo,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
