import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_principal.dart';
import '../widgets/cabecalho_auth.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  void _cadastrar() {
    if (!_formKey.currentState!.validate()) return;

    final erro = context.read<AuthService>().cadastrar(
          _nomeCtrl.text,
          _emailCtrl.text,
          _senhaCtrl.text,
        );

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: AppCores.vermelho),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado! Agora é só fazer login.'),
        backgroundColor: AppCores.petroleo,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                const CabecalhoAuth(
                  titulo: 'Criar conta',
                  subtitulo: 'Leva menos de um minuto',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppCores.branco),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
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
                      children: [
                        TextFormField(
                          controller: _nomeCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Nome',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe seu nome'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (v) => (v == null || !v.contains('@'))
                              ? 'Informe um e-mail válido'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaCtrl,
                          obscureText: _ocultarSenha,
                          decoration: InputDecoration(
                            hintText: 'Senha (mín. 6 caracteres)',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_ocultarSenha
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                              onPressed: () =>
                                  setState(() => _ocultarSenha = !_ocultarSenha),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'A senha precisa ter 6 caracteres ou mais'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmarCtrl,
                          obscureText: _ocultarSenha,
                          decoration: const InputDecoration(
                            hintText: 'Confirmar senha',
                            prefixIcon: Icon(Icons.lock_reset_rounded),
                          ),
                          validator: (v) => v != _senhaCtrl.text
                              ? 'As senhas não conferem'
                              : null,
                        ),
                        const SizedBox(height: 28),
                        BotaoPrincipal(
                          texto: 'Cadastrar',
                          icone: Icons.how_to_reg_rounded,
                          onPressed: _cadastrar,
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
