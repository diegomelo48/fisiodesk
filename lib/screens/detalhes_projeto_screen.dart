import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../dialogs/editar_projeto_dialog.dart';
import '../models/etapa.dart';
import '../models/projeto.dart';
import '../services/equipe_repository.dart';
import '../services/etapas_repository.dart';
import '../services/projetos_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/etapa_card.dart';
import 'etapa_detalhe_screen.dart';
import 'nova_etapa_screen.dart';

/// Equivalente a DetalhesProjetoEtapaActivity / detalhes_projeto_etapa_activity.xml.
class DetalhesProjetoScreen extends StatefulWidget {
  final String idProjeto;
  const DetalhesProjetoScreen({super.key, required this.idProjeto});

  @override
  State<DetalhesProjetoScreen> createState() => _DetalhesProjetoScreenState();
}

class _DetalhesProjetoScreenState extends State<DetalhesProjetoScreen> {
  final _projetosRepository = ProjetosRepository();
  final _etapasRepository = EtapasRepository();
  final _equipeRepository = EquipeRepository();

  Projeto? _projeto;
  String? _fotoResponsavel;
  List<Etapa> _etapas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTudo();
  }

  Future<void> _carregarTudo() async {
    setState(() => _carregando = true);
    final projeto = await _projetosRepository.buscarPorId(widget.idProjeto);
    final etapas = await _etapasRepository.buscarPorProjeto(widget.idProjeto);

    String? foto;
    if (projeto != null) {
      // Equivalente a buscarEExibirFotoResponsavel: procura na Equipe do
      // dono do projeto pelo nome+email do responsável, para achar a foto.
      final equipe = await _equipeRepository.buscarEquipeUmaVez(projeto.uid);
      final match = equipe.where((e) =>
          e.nome == projeto.responsavel && e.email == projeto.emailResponsavel);
      if (match.isNotEmpty) foto = match.first.fotoUrl;
    }

    if (!mounted) return;
    setState(() {
      _projeto = projeto;
      _etapas = etapas;
      _fotoResponsavel = foto;
      _carregando = false;
    });
  }

  Future<void> _mudarStatus(String novoStatus) async {
    final projeto = _projeto;
    if (projeto == null) return;
    final atualizado = projeto.copyWith(status: novoStatus);
    setState(() => _projeto = atualizado);
    await _projetosRepository.atualizar(atualizado);
  }

  Future<void> _editarProjeto() async {
    final projeto = _projeto;
    if (projeto == null) return;
    final resultado = await mostrarDialogEditarProjeto(context, projeto);
    if (resultado == null) return;

    final atualizado = projeto.copyWith(
      nomeProjeto: resultado.nome,
      descricao: resultado.descricao,
      categoria: resultado.categoria,
      responsavel: resultado.responsavel,
      emailResponsavel: resultado.emailResponsavel,
      prazo: resultado.prazo,
    );
    await _projetosRepository.atualizar(atualizado);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Projeto atualizado!')));
    _carregarTudo();
  }

  Future<void> _novaEtapa() async {
    final atualizou = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => NovaEtapaScreen(idProjeto: widget.idProjeto),
    ));
    if (atualizou == true) _carregarTudo();
  }

  Color _corCard(String statusAlvo) {
    return (_projeto?.status == statusAlvo) ? const Color(0xFFDDDDDD) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final projeto = _projeto;
    if (projeto == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Projeto')),
        body: const Center(child: Text('Projeto não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(projeto.nomeProjeto)),
      body: RefreshIndicator(
        onRefresh: _carregarTudo,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _editarProjeto,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Editar'),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                      iconeAssetParaCategoria(projeto.categoria),
                      width: 60,
                      height: 60,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(projeto.nomeProjeto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textoPrincipal)),
                          Text(projeto.categoria,
                              style: const TextStyle(
                                  fontSize: 18, color: AppColors.textoPrincipal)),
                          Text(projeto.descricao,
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.textoPrincipal)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text('Status',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textoPrincipal)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatusCard(
                  texto: 'Não Iniciado',
                  corBorda: AppColors.naoIniciado,
                  corFundo: _corCard('não iniciado'),
                  onTap: () => _mudarStatus('não iniciado'),
                ),
                _StatusCard(
                  texto: 'Iniciado',
                  corBorda: AppColors.iniciado,
                  corFundo: _corCard('iniciado'),
                  onTap: () => _mudarStatus('iniciado'),
                ),
                _StatusCard(
                  texto: 'Finalizado',
                  corBorda: AppColors.finalizado,
                  corFundo: _corCard('finalizado'),
                  onTap: () => _mudarStatus('finalizado'),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Prazo',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textoPrincipal)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(projeto.prazo,
                  style: const TextStyle(fontSize: 18, color: AppColors.textoPrincipal)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text('Responsável',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textoPrincipal)),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: (_fotoResponsavel != null && _fotoResponsavel!.isNotEmpty)
                      ? CachedNetworkImageProvider(_fotoResponsavel!)
                      : null,
                  child: (_fotoResponsavel == null || _fotoResponsavel!.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(projeto.responsavel.isEmpty ? 'Nome' : projeto.responsavel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
                subtitle: Text(projeto.emailResponsavel ?? 'Email',
                    style: const TextStyle(color: AppColors.textoPrincipal)),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Etapas Iniciadas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textoPrincipal)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _novaEtapa,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nova Etapa'),
                ),
              ],
            ),
            if (_etapas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nenhuma etapa iniciada', style: TextStyle(color: Colors.grey)),
              )
            else
              for (final etapa in _etapas)
                EtapaCard(
                  etapa: etapa,
                  nomeProjeto: projeto.nomeProjeto,
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EtapaDetalheScreen(
                        idEtapa: etapa.id,
                        idProjeto: widget.idProjeto,
                      ),
                    ));
                    _carregarTudo();
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String texto;
  final Color corBorda;
  final Color corFundo;
  final VoidCallback onTap;

  const _StatusCard({
    required this.texto,
    required this.corBorda,
    required this.corFundo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 60,
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: corBorda, width: 2),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrincipal),
        ),
      ),
    );
  }
}
