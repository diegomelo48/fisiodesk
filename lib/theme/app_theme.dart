import 'package:flutter/material.dart';

/// Cores extraídas dos recursos originais do Android:
/// - btn_verde  -> ação primária / confirmar
/// - btn_vermelho -> ação de cancelar
/// - #1C1C1C -> cor de texto padrão
/// - #0000FF -> links (autoLink="web", email dos autores)
class AppColors {
  static const verde = Color(0xFF2E7D32);
  static const vermelho = Color(0xFFC62828);
  static const textoPrincipal = Color(0xFF1C1C1C);
  static const azulLink = Color(0xFF0000FF);
  static const background = Color(0xFFF5F5F5);
  static const naoIniciado = Color(0xFFFF0000);
  static const iniciado = Color(0xFFF6CC22);
  static const finalizado = Color(0xFF006400);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verde,
        primary: AppColors.verde,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.verde,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textoPrincipal),
        bodyLarge: TextStyle(color: AppColors.textoPrincipal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verde,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.verde,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.verde,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

/// Botão verde reutilizável (equivalente a @drawable/btn_verde)
class BotaoVerde extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icone;
  const BotaoVerde({super.key, required this.texto, required this.onPressed, this.icone});

  @override
  Widget build(BuildContext context) {
    if (icone != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone, size: 18),
        label: Text(texto),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(texto)),
    );
  }
}

/// Botão vermelho reutilizável (equivalente a @drawable/btn_vermelho)
class BotaoVermelho extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  const BotaoVermelho({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.vermelho),
      child: Text(texto),
    );
  }
}
