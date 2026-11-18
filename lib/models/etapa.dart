/// Equivalente a Etapa.java (nó "Etapas/{id}").
class Etapa {
  final String id;
  final String nomeEtapa;
  final String? categoria;
  final String descricao;
  final String responsavel; // nome do responsável (legado)
  final String prazo;
  final String uid; // uid de quem criou a etapa
  final String idProjeto;
  final bool concluido;
  final String? texto; // comentários
  final String? link; // links de arquivos
  final String? imagem; // links de imagens
  final String? iconeEtapa;
  final String? responsavelNome;
  final String? responsavelEmail;
  final String? responsavelFotoUrl;
  final String? uidResponsavel;

  Etapa({
    required this.id,
    required this.nomeEtapa,
    required this.descricao,
    required this.responsavel,
    required this.prazo,
    required this.uid,
    required this.idProjeto,
    this.categoria,
    this.concluido = false,
    this.texto,
    this.link,
    this.imagem,
    this.iconeEtapa,
    this.responsavelNome,
    this.responsavelEmail,
    this.responsavelFotoUrl,
    this.uidResponsavel,
  });

  factory Etapa.fromMap(String id, Map<dynamic, dynamic> map) {
    return Etapa(
      id: id,
      nomeEtapa: map['nomeEtapa'] ?? '',
      categoria: map['categoria'],
      descricao: map['descricao'] ?? '',
      responsavel: map['responsavel'] ?? '',
      prazo: map['prazo'] ?? '',
      uid: map['uid'] ?? '',
      idProjeto: map['idProjeto'] ?? '',
      concluido: map['concluido'] == true,
      texto: map['texto'],
      link: map['link'],
      imagem: map['imagem'],
      iconeEtapa: map['iconeEtapa'],
      responsavelNome: map['responsavelNome'],
      responsavelEmail: map['responsavelEmail'],
      responsavelFotoUrl: map['responsavelFotoUrl'],
      uidResponsavel: map['uidResponsavel'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nomeEtapa': nomeEtapa,
        'categoria': categoria,
        'descricao': descricao,
        'responsavel': responsavel,
        'prazo': prazo,
        'uid': uid,
        'idProjeto': idProjeto,
        'concluido': concluido,
        'texto': texto,
        'link': link,
        'imagem': imagem,
        'iconeEtapa': iconeEtapa,
        'responsavelNome': responsavelNome,
        'responsavelEmail': responsavelEmail,
        'responsavelFotoUrl': responsavelFotoUrl,
        'uidResponsavel': uidResponsavel,
      };

  Etapa copyWith({
    String? nomeEtapa,
    String? descricao,
    bool? concluido,
    String? texto,
    String? link,
    String? imagem,
    String? prazo,
    String? responsavelNome,
    String? responsavelEmail,
    String? responsavelFotoUrl,
    String? uidResponsavel,
  }) {
    return Etapa(
      id: id,
      nomeEtapa: nomeEtapa ?? this.nomeEtapa,
      categoria: categoria,
      descricao: descricao ?? this.descricao,
      responsavel: responsavel,
      prazo: prazo ?? this.prazo,
      uid: uid,
      idProjeto: idProjeto,
      concluido: concluido ?? this.concluido,
      texto: texto ?? this.texto,
      link: link ?? this.link,
      imagem: imagem ?? this.imagem,
      iconeEtapa: iconeEtapa,
      responsavelNome: responsavelNome ?? this.responsavelNome,
      responsavelEmail: responsavelEmail ?? this.responsavelEmail,
      responsavelFotoUrl: responsavelFotoUrl ?? this.responsavelFotoUrl,
      uidResponsavel: uidResponsavel ?? this.uidResponsavel,
    );
  }
}
