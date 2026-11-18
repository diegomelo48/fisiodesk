import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dialogs/add_responsavel_dialog.dart';
import '../models/etapa.dart';
import '../models/projeto.dart';
import '../services/auth_service.dart';
import '../services/etapas_repository.dart';
import '../theme/app_theme.dart';

/// Equivalente a EtapasActivity / activity_etapas.xml: carrega, exibe e
/// permite editar uma etapa existente (nome, descrição, concluído,
/// responsável, prazo, comentários e links).
class EtapaDetalheScreen extends StatefulWidget {
  final String idEtapa;
  final String idProjeto;

  const EtapaDetalheScreen({
    super.key,
    required this.idEtapa,
    required this.idProjeto,
  });

  @override
  State<EtapaDetalheScreen> createState() => _EtapaDetalheScreenState();
}

class _EtapaDetalheScreenState extends State<EtapaDetalheScreen> {
  final _etapasRepository = EtapasRepository();
  final _authService = AuthService();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _comentarioController = TextEditingController();
  final _linkArquivoController = TextEditingController();
  final _linkImagemController = TextEditingController();

  Etapa? _etapa;
  bool _carregando = true;
  bool _salvando = false;
  bool _concluido = false;
  DateTime _prazo = DateTime.now();

  // Responsável selecionado (pode mudar via _selecionarResponsavel).
  String? _respNome;
  String? _respEmail;
  String? _respFotoUrl;
  String? _respUid;

  @override
  void initState() {
    super.initState();
    _carregarEtapa();
  }

  Future<void> _carregarEtapa() async {
    final etapa = await _etapasRepository.buscarPorId(widget.idEtapa);
    if (etapa == null) {
      if (mounted) setState(() => _carregando = false);
      return;
    }
    setState(() {
      _etapa = etapa;
      _nomeController.text = etapa.nomeEtapa;
      _descricaoController.text = etapa.descricao;
      _comentarioController.text = etapa.texto ?? '';
      _linkArquivoController.text = etapa.link ?? '';
      _linkImagemController.text = etapa.imagem ?? '';
      _concluido = etapa.concluido;
      _respNome = etapa.responsavelNome;
      _respEmail = etapa.responsavelEmail;
      _respFotoUrl = etapa.responsavelFotoUrl;
      _respUid = etapa.uidResponsavel;
      if (etapa.prazo.isNotEmpty) {
        try {
          _prazo = _dateFormat.parseStrict(etapa.prazo);
        } catch (_) {}
      }
      _carregando = false;
    });
  }

  Future<void> _selecionarResponsavel() async {
    final selecionado = await mostrarDialogSelecionarResponsavel(context);
    if (selecionado == null) return;
    setState(() {
      _respNome = selecionado.nome;
      _respEmail = selecionado.email;
      _respFotoUrl = selecionado.fotoUrl;
      _respUid = selecionado.uid;
    });
  }

  Future<void> _salvar() async {
    final etapaAtual = _etapa;
    if (etapaAtual == null) return;

    setState(() => _salvando = true);
    try {
      final atualizada = etapaAtual.copyWith(
        nomeEtapa: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        concluido: _concluido,
        texto: _comentarioController.text.trim(),
        link: _linkArquivoController.text.trim(),
        imagem: _linkImagemController.text.trim(),
        prazo: _dateFormat.format(_prazo),
        responsavelNome: _respNome,
        responsavelEmail: _respEmail,
        responsavelFotoUrl: _respFotoUrl,
        uidResponsavel: _respUid,
      );
      await _etapasRepository.atualizar(atualizada);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Etapa atualizada com sucesso')));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao salvar etapa')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _comentarioController.dispose();
    _linkArquivoController.dispose();
    _linkImagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_etapa == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Etapa')),
        body: const Center(child: Text('Etapa não encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Etapa')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    iconeAssetParaEtapa(_etapa!.nomeEtapa),
                    width: 70,
                    height: 70,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _nomeController,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextField(controller: _descricaoController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _concluido,
            onChanged: (v) => setState(() => _concluido = v),
            title: const Text('Marcar como concluído',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
          ),
          const _Rotulo('Prazo'),
          CalendarDatePicker(
            initialDate: _prazo,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
            onDateChanged: (d) => setState(() => _prazo = d),
          ),
          const _Rotulo('Responsável'),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    (_respFotoUrl != null && _respFotoUrl!.isNotEmpty)
                        ? CachedNetworkImageProvider(_respFotoUrl!)
                        : null,
                child: (_respFotoUrl == null || _respFotoUrl!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(_respNome ?? 'Nome',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
              subtitle: Text(_respEmail ?? 'Email',
                  style: const TextStyle(color: AppColors.textoPrincipal)),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _selecionarResponsavel,
              ),
            ),
          ),
          const _Rotulo('Resultados'),
          const Text('Comentários', style: TextStyle(color: AppColors.textoPrincipal)),
          const SizedBox(height: 4),
          TextField(
            controller: _comentarioController,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Inserção de texto'),
          ),
          const SizedBox(height: 12),
          const Text('Links de arquivos', style: TextStyle(color: AppColors.textoPrincipal)),
          const SizedBox(height: 4),
          TextField(
            controller: _linkArquivoController,
            decoration: const InputDecoration(hintText: 'Inserção de link (drive)'),
          ),
          const SizedBox(height: 12),
          const Text('Links de imagens', style: TextStyle(color: AppColors.textoPrincipal)),
          const SizedBox(height: 4),
          TextField(
            controller: _linkImagemController,
            decoration: const InputDecoration(hintText: 'Inserção de link (drive)'),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
        ],
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
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        texto,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textoPrincipal),
      ),
    );
  }
}
