import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cabeçalho das telas de login e cadastro, com círculos decorativos.
class CabecalhoAuth extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const CabecalhoAuth({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: Stack(
        children: [
          // Círculos decorativos
          Positioned(
            top: -40,
            right: -30,
            child: _circulo(140, AppCores.amarelo),
          ),
          Positioned(
            bottom: 10,
            left: -25,
            child: _circulo(70, AppCores.petroleo),
          ),
          Positioned(
            top: 40,
            left: 40,
            child: _circulo(18, AppCores.amarelo),
          ),
          // Conteúdo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppCores.amarelo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    size: 38,
                    color: AppCores.petroleoEscuro,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: AppCores.branco,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circulo(double tamanho, Color cor) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
    );
  }
}
