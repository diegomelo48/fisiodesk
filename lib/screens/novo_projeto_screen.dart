import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/equipe.dart';
import '../models/projeto.dart';
import '../services/auth_service.dart';
import '../services/equipe_repository.dart';
import '../services/projetos_repository.dart';
import '../theme/app_theme.dart';

/// Equivalente a NovoProjetoActivity.
class NovoProjetoScreen extends StatefulWidget {
  const NovoProjetoScreen({super.key});

  @override
  State<NovoProjetoScreen> createState() => _NovoProjetoScreenState();
}

class _NovoProjetoScreenState extends State<NovoProjetoScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _authService = AuthService();
  final _equipeRepository = EquipeRepository();
  final _projetosRepository = ProjetosRepository();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  String? _categoriaSelecionada;
  Equipe? _responsavelSelecionado;
  DateTime _prazo = DateTime.now();
  List<Equipe> _equipe = [];
  bool _carregandoEquipe = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarEquipe();
  }

  Future<void> _carregarEquipe() async {
    final uid = _authService.uidAtual;
    if (uid == null) return;
    final lista = await _equipeRepository.buscarEquipeUmaVez(uid);
    if (mounted) {
      setState(() {
        _equipe = lista.isEmpty
            ? [Equipe(id: '', nome: 'Nenhuma equipe encontrada!', email: '', telefone: '', uid: '')]
            : lista;
        _carregandoEquipe = false;
      });
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _descricaoController.clear();
    setState(() {
      _categoriaSelecionada = null;
      _responsavelSelecionado = null;
      _prazo = DateTime.now();
    });
  }

  Future<void> _salvar() async {
    final uid = _authService.uidAtual;
    if (uid == null) return;

    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (nome.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => _salvando = true);
    try {
      final projeto = Projeto(
        id: '',
        categoria: _categoriaSelecionada ?? kCategorias.first,
        nomeProjeto: nome,
        descricao: descricao,
        responsavel: _responsavelSelecionado?.nome ?? '',
        prazo: _dateFormat.format(_prazo),
        uid: uid,
        emailResponsavel: _responsavelSelecionado?.email,
        nomeResponsavel: _responsavelSelecionado?.nome,
      );
      await _projetosRepository.criar(projeto);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Projeto salvo com sucesso!')));
      _limparCampos();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao salvar')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Projeto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Rotulo('Categoria'),
                  DropdownButtonFormField<String>(
                    value: _categoriaSelecionada,
                    items: kCategorias
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _categoriaSelecionada = v),
                    decoration: const InputDecoration(),
                  ),
                  const _Rotulo('Nome do Projeto'),
                  TextField(
                    controller: _nomeController,
                    decoration:
                        const InputDecoration(hintText: 'Digite o nome do projeto'),
                  ),
                  const _Rotulo('Descrição'),
                  TextField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        hintText: 'Digite aqui a descrição do projeto'),
                  ),
                  const _Rotulo('Responsável'),
                  _carregandoEquipe
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        )
                      : DropdownButtonFormField<Equipe>(
                          value: _responsavelSelecionado,
                          items: _equipe
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e.nome)))
                              .toList(),
                          onChanged: (v) => setState(() => _responsavelSelecionado = v),
                          decoration: const InputDecoration(),
                        ),
                  const _Rotulo('Prazo'),
                  CalendarDatePicker(
                    initialDate: _prazo,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                    onDateChanged: (d) => setState(() => _prazo = d),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotaoVermelho(texto: 'Cancelar', onPressed: _limparCampos),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: _salvando ? null : _salvar,
                          child: Text(_salvando ? 'Salvando...' : 'Salvar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        texto,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textoPrincipal),
      ),
    );
  }
}
