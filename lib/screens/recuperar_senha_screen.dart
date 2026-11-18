import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Equivalente a RecuperarSenhaActivity.
class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _recuperar() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _carregando = true);
    try {
      await _authService.recuperarSenha(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação enviado!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthService.mensagemErro(e))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Center(
              child: Image.asset(
                'assets/images/bg.png',
                width: 150,
                height: 150,
                errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Seu email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 15),
            BotaoVerde(
              texto: _carregando ? 'Enviando...' : 'Recuperar senha',
              onPressed: _carregando ? null : _recuperar,
            ),
          ],
        ),
      ),
    );
  }
}
