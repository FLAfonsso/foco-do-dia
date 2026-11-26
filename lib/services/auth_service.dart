import 'package:flutter/foundation.dart';

import '../models/usuario.dart';

/// Cuida do cadastro e do login dos usuários.
/// Os dados ficam em memória (o enunciado não exige Firebase funcionando).
class AuthService extends ChangeNotifier {
  final List<Usuario> _usuarios = [];
  Usuario? _usuarioLogado;

  Usuario? get usuarioLogado => _usuarioLogado;

  /// Retorna null se deu certo, ou uma mensagem de erro.
  String? cadastrar(String nome, String email, String senha) {
    final emailLimpo = email.trim().toLowerCase();

    if (nome.trim().isEmpty || emailLimpo.isEmpty || senha.isEmpty) {
      return 'Preencha todos os campos.';
    }
    if (!emailLimpo.contains('@') || !emailLimpo.contains('.')) {
      return 'E-mail inválido.';
    }
    if (senha.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }
    if (_usuarios.any((u) => u.email == emailLimpo)) {
      return 'Este e-mail já está cadastrado.';
    }

    _usuarios.add(Usuario(nome: nome.trim(), email: emailLimpo, senha: senha));
    return null;
  }

  /// Retorna null se o login deu certo, ou uma mensagem de erro.
  String? login(String email, String senha) {
    final emailLimpo = email.trim().toLowerCase();
    final encontrados =
        _usuarios.where((u) => u.email == emailLimpo && u.senha == senha);

    if (encontrados.isEmpty) {
      return 'E-mail ou senha incorretos.';
    }

    _usuarioLogado = encontrados.first;
    notifyListeners();
    return null;
  }

  void sair() {
    _usuarioLogado = null;
    notifyListeners();
  }
}
