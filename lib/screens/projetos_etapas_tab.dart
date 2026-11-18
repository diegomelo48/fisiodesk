import 'package:flutter/material.dart';
import '../models/etapa.dart';
import '../models/projeto.dart';
import '../services/auth_service.dart';
import '../services/etapas_repository.dart';
import '../services/projetos_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/etapa_card.dart';
import '../widgets/projeto_card.dart';
import 'detalhes_projeto_screen.dart';
import 'etapa_detalhe_screen.dart';
import 'novo_projeto_screen.dart';

/// Equivalente a ProjetosEtapasFragment / fragment_projetos_etapas.xml.
class ProjetosEtapasTab extends StatefulWidget {
  const ProjetosEtapasTab({super.key});

  @override
  State<ProjetosEtapasTab> createState() => _ProjetosEtapasTabState();
}

class _ProjetosEtapasTabState extends State<ProjetosEtapasTab> {
  final _authService = AuthService();
  final _projetosRepository = ProjetosRepository();
  final _etapasRepository = EtapasRepository();

  List<Projeto> _projetos = [];
  List<Etapa> _etapas = [];
  final Map<String, String> _nomesProjetoCache = {};
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
    final projetos = await _projetosRepository.buscarMeusProjetos(uid);
    final etapas = await _etapasRepository.buscarMinhasEtapasComProjeto(uid);
    if (!mounted) return;
    setState(() {
      _projetos = projetos;
      _etapas = etapas;
      _carregando = false;
    });
  }

  Future<String> _nomeProjeto(String idProjeto) async {
    if (_nomesProjetoCache.containsKey(idProjeto)) {
      return _nomesProjetoCache[idProjeto]!;
    }
    final nome =
        await _etapasRepository.buscarNomeProjeto(idProjeto) ?? 'Projeto não encontrado';
    _nomesProjetoCache[idProjeto] = nome;
    return nome;
  }

  Future<void> _novoProjeto() async {
    final criou = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const NovoProjetoScreen()));
    if (criou == true) _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 90, left: 5, right: 5),
        children: [
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, top: 12),
                  child: Text('Meus Projetos',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textoPrincipal)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 5),
                child: ElevatedButton.icon(
                  onPressed: _novoProjeto,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Novo Projeto'),
                ),
              ),
            ],
          ),
          if (_carregando)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_projetos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nenhum projeto ainda',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18)),
            )
          else
            for (final projeto in _projetos)
              ProjetoCard(
                projeto: projeto,
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => DetalhesProjetoScreen(idProjeto: projeto.id),
                  ));
                  _carregar();
                },
              ),
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text('Etapas Iniciadas',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textoPrincipal)),
          ),
          if (!_carregando)
            for (final etapa in _etapas)
              FutureBuilder<String>(
                future: _nomeProjeto(etapa.idProjeto),
                builder: (context, snapshot) {
                  return EtapaCard(
                    etapa: etapa,
                    nomeProjeto: snapshot.data,
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            EtapaDetalheScreen(idEtapa: etapa.id, idProjeto: etapa.idProjeto),
                      ));
                      _carregar();
                    },
                  );
                },
              ),
        ],
      ),
    );
  }
}
