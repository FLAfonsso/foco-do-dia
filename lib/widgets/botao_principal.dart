import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Botão amarelo reutilizado em várias telas.
class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icone;

  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.amarelo,
          foregroundColor: AppCores.petroleoEscuro,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icone != null) ...[
              Icon(icone),
              const SizedBox(width: 8),
            ],
            // Flexible evita que o texto estoure em telas estreitas
            Flexible(
              child: Text(
                texto,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
