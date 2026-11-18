/// Equivalente a Usuario.java (nó "Usuarios" no Realtime Database).
class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String telefone;
  final String? fotoUrl;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.telefone,
    this.fotoUrl,
  });

  factory Usuario.fromMap(Map<dynamic, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      fotoUrl: map['fotoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'fotoUrl': fotoUrl,
      };
}
