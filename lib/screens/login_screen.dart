import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Equivalente a LoginActivity.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty) {
      _mostrarErro('Digite o e-mail');
      return;
    }
    if (senha.isEmpty) {
      _mostrarErro('Digite a senha');
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authService.login(email, senha);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      _mostrarErro(AuthService.mensagemErro(e));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              BotaoVerde(
                texto: _carregando ? 'Entrando...' : 'Entrar',
                onPressed: _carregando ? null : _entrar,
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/recuperar-senha'),
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(fontSize: 17, color: AppColors.azulLink),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/cadastro'),
                child: const Text(
                  'Não tem conta? Cadastre-se',
                  style: TextStyle(fontSize: 17, color: AppColors.azulLink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
