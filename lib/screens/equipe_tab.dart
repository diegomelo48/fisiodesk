import 'package:flutter/material.dart';
import '../dialogs/add_equipe_dialog.dart';
import '../models/equipe.dart';
import '../services/auth_service.dart';
import '../services/equipe_repository.dart';
import '../services/storage_service.dart';
import '../widgets/equipe_card.dart';

/// Equivalente a EquipeFragment / fragment_equipe.xml: lista da equipe do
/// usuário logado, com FAB para adicionar e menu por item para editar/excluir.
class EquipeTab extends StatefulWidget {
  const EquipeTab({super.key});

  @override
  State<EquipeTab> createState() => _EquipeTabState();
}

class _EquipeTabState extends State<EquipeTab> {
  final _authService = AuthService();
  final _equipeRepository = EquipeRepository();
  final _storageService = StorageService();

  List<Equipe> _lista = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final uid = _authService.uidAtual;
    if (uid == null) return;
    setState(() => _carregando = true);
    final lista = await _equipeRepository.buscarEquipeUmaVez(uid);
    if (!mounted) return;
    setState(() {
      _lista = lista;
      _carregando = false;
    });
  }

  Future<void> _adicionarOuEditar({Equipe? existente}) async {
    final resultado =
        await mostrarDialogAddEditarEquipe(context, equipeExistente: existente);
    if (resultado == null) return;

    final uid = _authService.uidAtual;
    if (uid == null) return;

    String? fotoUrl = existente?.fotoUrl;
    final idMembro = existente?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    if (resultado.novaFoto != null) {
      fotoUrl = await _storageService.enviarFotoEquipe(idMembro, resultado.novaFoto!);
    }

    final equipe = Equipe(
      id: idMembro,
      nome: resultado.nome,
      email: resultado.email,
      telefone: resultado.telefone,
      uid: uid,
      fotoUrl: fotoUrl,
    );

    if (existente != null) {
      await _equipeRepository.atualizar(uid, equipe);
    } else {
      await _equipeRepository.adicionar(uid, equipe);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Equipe salva com sucesso!')));
    _carregar();
  }

  Future<void> _confirmarExclusao(Equipe equipe) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir'),
        content: Text('Tem certeza que deseja excluir ${equipe.nome}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmou != true) return;

    final uid = _authService.uidAtual;
    if (uid == null) return;
    await _equipeRepository.excluir(uid, equipe.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Equipe excluída')));
    _carregar();
  }

  void _abrirMenu(Equipe equipe) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _adicionarOuEditar(existente: equipe);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _confirmarExclusao(equipe);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregar,
              child: _lista.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.only(top: 100),
                      children: const [
                        Center(child: Text('Nenhum membro na equipe ainda')),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
                      children: [
                        for (final equipe in _lista)
                          EquipeCard(
                            equipe: equipe,
                            onMenu: () => _abrirMenu(equipe),
                          ),
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditar(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
