import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/usuarios_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/telefone_formatter.dart';

/// Equivalente a CadastroActivity.
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

  final _authService = AuthService();
  final _storageService = StorageService();
  final _usuariosRepository = UsuariosRepository();

  File? _foto;
  bool _carregando = false;

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() => _foto = File(imagem.path));
    }
  }

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      final credencial = await _authService.cadastrar(email, senha);
      final uid = credencial.user!.uid;

      String? fotoUrl;
      if (_foto != null) {
        fotoUrl = await _storageService.enviarFotoPerfil(uid, _foto!);
      }

      final usuario = Usuario(
        uid: uid,
        nome: nome,
        email: email,
        telefone: telefone,
        fotoUrl: fotoUrl,
      );
      await _usuariosRepository.salvar(usuario);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado! Seja bem-vindo!')),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AuthService.mensagemErro(e))));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _foto != null ? FileImage(_foto!) : null,
                child: _foto == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: _selecionarFoto,
                  child: const Text('Selecionar Foto'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome de usuário',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [TelefoneFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
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
                    if (_carregando) ...[
                      const SizedBox(height: 15),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            BotaoVerde(
              texto: _carregando ? 'Cadastrando...' : 'Cadastrar',
              onPressed: _carregando ? null : _cadastrar,
            ),
          ],
        ),
      ),
    );
  }
}
