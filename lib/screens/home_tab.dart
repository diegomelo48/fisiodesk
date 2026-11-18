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

/// Equivalente a HomeFragment / fragment_home.xml.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
    final etapas = await _etapasRepository.buscarMinhasEtapas(uid);
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
    final nome = await _etapasRepository.buscarNomeProjeto(idProjeto) ??
        'Projeto não encontrado';
    _nomesProjetoCache[idProjeto] = nome;
    return nome;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          Image.asset(
            'assets/images/bg.png',
            width: 180,
            height: 180,
            errorBuilder: (_, __, ___) => const SizedBox(height: 180),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Assistente para projetos tecnológicos em Fisioterapia e reabilitação',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textoPrincipal),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text('Meus projetos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textoPrincipal)),
          ),
          if (_carregando)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_projetos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nenhum projeto iniciado',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18)),
            )
          else
            for (final projeto in _projetos)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ProjetoCard(
                  projeto: projeto,
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DetalhesProjetoScreen(idProjeto: projeto.id),
                    ));
                    _carregar();
                  },
                ),
              ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text('Minhas etapas iniciadas',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textoPrincipal)),
          ),
          if (!_carregando && _etapas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nenhuma etapa iniciada',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            )
          else if (!_carregando)
            for (final etapa in _etapas)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FutureBuilder<String>(
                  future: _nomeProjeto(etapa.idProjeto),
                  builder: (context, snapshot) {
                    return EtapaCard(
                      etapa: etapa,
                      nomeProjeto: snapshot.data,
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EtapaDetalheScreen(
                              idEtapa: etapa.id, idProjeto: etapa.idProjeto),
                        ));
                        _carregar();
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
