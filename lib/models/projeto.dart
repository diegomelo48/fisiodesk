/// Equivalente a Projeto.java (nó "projetos/{id}").
class Projeto {
  final String id;
  final String categoria;
  final String nomeProjeto;
  final String descricao;
  final String responsavel;
  final String prazo; // formato dd/MM/yyyy, igual ao Android original
  final String? status; // "não iniciado" | "iniciado" | "finalizado"
  final String uid; // uid do criador do projeto
  final String? emailResponsavel;
  final String? nomeResponsavel;

  Projeto({
    required this.id,
    required this.categoria,
    required this.nomeProjeto,
    required this.descricao,
    required this.responsavel,
    required this.prazo,
    required this.uid,
    this.status,
    this.emailResponsavel,
    this.nomeResponsavel,
  });

  factory Projeto.fromMap(String id, Map<dynamic, dynamic> map) {
    return Projeto(
      id: id,
      categoria: map['categoria'] ?? '',
      nomeProjeto: map['nomeProjeto'] ?? '',
      descricao: map['descricao'] ?? '',
      responsavel: map['responsavel'] ?? '',
      prazo: map['prazo'] ?? '',
      uid: map['uid'] ?? '',
      status: map['status'],
      emailResponsavel: map['emailResponsavel'],
      nomeResponsavel: map['nomeResponsavel'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoria': categoria,
        'nomeProjeto': nomeProjeto,
        'descricao': descricao,
        'responsavel': responsavel,
        'prazo': prazo,
        'uid': uid,
        'status': status,
        'emailResponsavel': emailResponsavel,
        'nomeResponsavel': nomeResponsavel,
      };

  Projeto copyWith({
    String? categoria,
    String? nomeProjeto,
    String? descricao,
    String? responsavel,
    String? prazo,
    String? status,
    String? emailResponsavel,
    String? nomeResponsavel,
  }) {
    return Projeto(
      id: id,
      categoria: categoria ?? this.categoria,
      nomeProjeto: nomeProjeto ?? this.nomeProjeto,
      descricao: descricao ?? this.descricao,
      responsavel: responsavel ?? this.responsavel,
      prazo: prazo ?? this.prazo,
      uid: uid,
      status: status ?? this.status,
      emailResponsavel: emailResponsavel ?? this.emailResponsavel,
      nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
    );
  }
}

/// As 10 categorias fixas usadas em NovoProjetoActivity / CategoriasFragment.
const List<String> kCategorias = [
  'Tecnologia móvel',
  'Tecnologia assistiva',
  'Gameterapia',
  'Realidade virtual',
  'Robótica',
  'Recursos de avaliação',
  'Cinesioterapia',
  'Produto educacional',
  'Eletrotermoterapia',
  'Recursos cardiorespiratório',
];

/// Equivalente a ProjetoAdapter.getIconForCategoria(): mapeia o nome da
/// categoria (como salvo no Firebase) para o asset de imagem correspondente.
String iconeAssetParaCategoria(String? categoria) {
  switch ((categoria ?? '').toLowerCase().trim()) {
    case 'tecnologia móvel':
    case 'tecnologia movel':
      return 'assets/images/tecnologia_movel.png';
    case 'tecnologia assistiva':
      return 'assets/images/tecnologia_assistiva.png';
    case 'gameterapia':
      return 'assets/images/gameterapia.png';
    case 'robótica':
    case 'robotica':
      return 'assets/images/robotica.png';
    case 'realidade virtual':
      return 'assets/images/realidade_virtual.png';
    case 'recursos de avaliação':
      return 'assets/images/recursos_avaliacao.png';
    case 'cinesioterapia':
      return 'assets/images/cinesioterapia.png';
    case 'eletrotermoterapia':
      return 'assets/images/eletrotermoterapia.png';
    case 'produto educacional':
      return 'assets/images/produto_educacional.png';
    case 'recursos cardiorespiratorio':
    case 'recursos cardiorrespiratório':
    case 'recursos cardiorespiratório':
      return 'assets/images/cardiorespiratorios.png';
    default:
      return 'assets/images/bg.png';
  }
}

/// Equivalente ao mapaCategorias usado em EtapasActivity / DetalhesProjetoEtapaActivity
/// para o ícone de cada etapa fixa do fluxo de projeto.
String iconeAssetParaEtapa(String? nomeEtapa) {
  switch (nomeEtapa) {
    case 'Problema e objetivos':
      return 'assets/images/problema_objetivos.png';
    case 'Pesquisa e Análise de dados':
    case 'Pesquisa e Análise':
      return 'assets/images/pesquisa_dados.png';
    case 'Conceito e Criação':
      return 'assets/images/conceito_criacao.png';
    case 'Especificações técnicas':
      return 'assets/images/especificacoes_tecnicas.png';
    case 'Protótipo e avaliação':
      return 'assets/images/prototipo_avaliacao.png';
    case 'Produto':
      return 'assets/images/produto.png';
    case 'Registro e Patente':
      return 'assets/images/registro_patente.png';
    default:
      return 'assets/images/bg.png';
  }
}

/// As 7 etapas fixas do fluxo de projeto (usado no spinner de NovaEtapaActivity).
const List<String> kEtapasFixas = [
  'Problema e objetivos',
  'Pesquisa e Análise de dados',
  'Conceito e Criação',
  'Especificações técnicas',
  'Protótipo e avaliação',
  'Produto',
  'Registro e Patente',
];
