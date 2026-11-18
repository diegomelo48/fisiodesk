/// Equivalente a Equipe.java (nó "Equipe/{uidDono}/{idMembro}").
class Equipe {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String uid; // uid do dono da lista de equipe (usuário logado)
  final String? fotoUrl;

  Equipe({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.uid,
    this.fotoUrl,
  });

  factory Equipe.fromMap(String id, Map<dynamic, dynamic> map) {
    return Equipe(
      id: id,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      uid: map['uid'] ?? '',
      fotoUrl: map['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'uid': uid,
        'fotoUrl': fotoUrl,
      };
}
