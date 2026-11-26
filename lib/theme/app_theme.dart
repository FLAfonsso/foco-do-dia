import 'package:flutter/material.dart';

/// Paleta de cores do app: azul-petróleo com amarelo vibrante.
class AppCores {
  static const petroleo = Color(0xFF0B4F6C);
  static const petroleoEscuro = Color(0xFF052F40);
  static const petroleoClaro = Color(0x330B4F6C); // petróleo com transparência
  static const amarelo = Color(0xFFFFD60A);
  static const creme = Color(0xFFFFF8E1);
  static const branco = Colors.white;
  static const vermelho = Color(0xFFE63946);
}

/// Tema global aplicado no MaterialApp.
class AppTheme {
  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppCores.petroleo,
        primary: AppCores.petroleo,
        secondary: AppCores.amarelo,
      ),
      scaffoldBackgroundColor: AppCores.petroleoEscuro,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppCores.branco,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppCores.petroleoClaro),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppCores.amarelo, width: 2),
        ),
        prefixIconColor: AppCores.petroleo,
      ),
    );
  }
}
