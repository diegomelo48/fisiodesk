import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Equivalente a SplashActivity: espera 2s e decide entre Home (se já
/// logado) ou Login (se não), lendo o FirebaseAuth.getCurrentUser().
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      final logado = _authService.usuarioAtual != null;
      Navigator.of(context)
          .pushReplacementNamed(logado ? '/home' : '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const FlutterLogo(size: 120),
          ),
        ),
      ),
    );
  }
}
