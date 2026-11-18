import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../dialogs/editar_perfil_dialog.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/conta_service.dart';
import '../services/storage_service.dart';
import '../services/usuarios_repository.dart';
import '../theme/app_theme.dart';

/// Equivalente a PerfilFragment / fragment_perfil.xml.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _authService = AuthService();
  final _usuariosRepository = UsuariosRepository();
  final _storageService = StorageService();
  final _contaService = ContaService();

  Usuario? _usuario;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final uid = _authService.uidAtual;
    if (uid == null) return;
    final usuario = await _usuariosRepository.buscar(uid);
    if (!mounted) return;
    setState(() {
      _usuario = usuario;
      _carregando = false;
    });
  }

  Future<void> _editar() async {
    final usuario = _usuario;
    final uid = _authService.uidAtual;
    if (usuario == null || uid == null) return;

    final resultado = await mostrarDialogEditarPerfil(context, usuario);
    if (resultado == null) return;

    try {
      if (resultado.novaSenha.isNotEmpty) {
        await _authService.atualizarSenha(resultado.novaSenha);
      }

      String? fotoUrl = usuario.fotoUrl;
      if (resultado.novaFoto != null) {
        fotoUrl = await _storageService.enviarFotoPerfil(uid, resultado.novaFoto!);
      }

      final atualizado = Usuario(
        uid: uid,
        nome: resultado.nome,
        email: resultado.email,
        telefone: resultado.telefone,
        fotoUrl: fotoUrl,
      );
      await _usuariosRepository.salvar(atualizado);

      if (!mounted) return;
      setState(() => _usuario = atualizado);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Perfil atualizado')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AuthService.mensagemErro(e))));
    }
  }


  // ---------------------------------------------------------------------
  // Exclusão de conta (exigida pela App Store - diretriz 5.1.1(v))
  // ---------------------------------------------------------------------

  Future<void> _excluirConta() async {
    // 1) Confirmação, explicando o que será apagado.
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta'),
        content: const Text(
          'Esta ação é permanente e não pode ser desfeita.\n\n'
          'Serão apagados definitivamente: seu perfil e foto, seus projetos, '
          'as etapas desses projetos e a sua equipe cadastrada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar',
                style: TextStyle(color: AppColors.vermelho)),
          ),
        ],
      ),
    );
    if (confirmou != true || !mounted) return;

    // 2) Pede a senha (o Firebase exige login recente para excluir a conta).
    final senha = await _pedirSenha();
    if (senha == null || senha.isEmpty || !mounted) return;

    // 3) Executa com indicador de progresso.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Excluindo conta...')),
            ],
          ),
        ),
      ),
    );

    String? erro;
    try {
      await _contaService.excluirConta(senha: senha);
    } catch (e) {
      erro = AuthService.mensagemErro(e);
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // fecha o progresso

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sua conta foi excluída.')),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  Future<String?> _pedirSenha() async {
    final controller = TextEditingController();
    final senha = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirme sua senha'),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Senha atual'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Excluir conta',
                style: TextStyle(color: AppColors.vermelho)),
          ),
        ],
      ),
    );
    controller.dispose();
    return senha;
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final usuario = _usuario;
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: (usuario?.fotoUrl != null && usuario!.fotoUrl!.isNotEmpty)
                  ? CachedNetworkImageProvider(usuario.fotoUrl!) as ImageProvider
                  : null,
              child: (usuario?.fotoUrl == null || usuario!.fotoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usuario?.nome ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.textoPrincipal)),
                  const SizedBox(height: 6),
                  Text(usuario?.email ?? '',
                      style: const TextStyle(fontSize: 16, color: AppColors.textoPrincipal)),
                  const SizedBox(height: 6),
                  Text(usuario?.telefone ?? '',
                      style: const TextStyle(fontSize: 16, color: AppColors.textoPrincipal)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          BotaoVerde(texto: 'Editar Perfil', onPressed: _editar, icone: Icons.edit),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _excluirConta,
            icon: const Icon(Icons.delete_forever, color: AppColors.vermelho),
            label: const Text('Excluir conta',
                style: TextStyle(color: AppColors.vermelho)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.vermelho),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Remove permanentemente sua conta e todos os seus dados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
