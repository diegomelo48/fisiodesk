import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/equipe.dart';
import '../models/etapa.dart';
import '../models/projeto.dart';
import '../services/auth_service.dart';
import '../services/equipe_repository.dart';
import '../services/etapas_repository.dart';
import '../theme/app_theme.dart';

/// Equivalente a NovaEtapaActivity.
class NovaEtapaScreen extends StatefulWidget {
  final String idProjeto;
  const NovaEtapaScreen({super.key, required this.idProjeto});

  @override
  State<NovaEtapaScreen> createState() => _NovaEtapaScreenState();
}

class _NovaEtapaScreenState extends State<NovaEtapaScreen> {
  final _descricaoController = TextEditingController();
  final _authService = AuthService();
  final _equipeRepository = EquipeRepository();
  final _etapasRepository = EtapasRepository();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  String? _etapaSelecionada;
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
        _equipe = lista;
        _carregandoEquipe = false;
      });
    }
  }

  Future<void> _salvar() async {
    final uid = _authService.uidAtual;
    if (uid == null) return;

    if (_etapaSelecionada == null || _responsavelSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final etapa = Etapa(
        id: '',
        nomeEtapa: _etapaSelecionada!,
        descricao: _descricaoController.text.trim(),
        responsavel: _responsavelSelecionado!.nome,
        prazo: _dateFormat.format(_prazo),
        uid: uid,
        idProjeto: widget.idProjeto,
        iconeEtapa: _etapaSelecionada,
        responsavelNome: _responsavelSelecionado!.nome,
        responsavelEmail: _responsavelSelecionado!.email,
        responsavelFotoUrl: _responsavelSelecionado!.fotoUrl,
        uidResponsavel: _responsavelSelecionado!.uid,
      );
      await _etapasRepository.criar(etapa);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Etapa salva com sucesso!')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar a etapa. Tente novamente.')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Etapa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _rotulo('Nome da Etapa'),
                DropdownButtonFormField<String>(
                  value: _etapaSelecionada,
                  items: kEtapasFixas
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _etapaSelecionada = v),
                  decoration: const InputDecoration(),
                ),
                _rotulo('Descrição'),
                TextField(
                  controller: _descricaoController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      hintText: 'Digite aqui a descrição do projeto'),
                ),
                _rotulo('Responsável'),
                _carregandoEquipe
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      )
                    : DropdownButtonFormField<Equipe>(
                        value: _responsavelSelecionado,
                        items: _equipe
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.nome)))
                            .toList(),
                        onChanged: (v) => setState(() => _responsavelSelecionado = v),
                        decoration: InputDecoration(
                          hintText:
                              _equipe.isEmpty ? 'Nenhum responsável encontrado!' : null,
                        ),
                      ),
                _rotulo('Prazo'),
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
                    BotaoVermelho(
                      texto: 'Cancelar',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
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
    );
  }

  Widget _rotulo(String texto) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            texto,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textoPrincipal),
          ),
        ),
      );
}
