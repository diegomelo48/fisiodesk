import 'package:firebase_database/firebase_database.dart';
import '../models/equipe.dart';

/// Equivalente a `FirebaseDatabase.getInstance().getReference("Equipe").child(uidAtual)`,
/// usado em NovoProjetoActivity, NovaEtapaActivity e EquipeFragment.
class EquipeRepository {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Equipe');

  Stream<List<Equipe>> observarEquipe(String uidDono) {
    return _ref.child(uidDono).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return <Equipe>[];
      final map = Map<dynamic, dynamic>.from(data as Map);
      return map.entries
          .map((e) => Equipe.fromMap(
              e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map)))
          .toList();
    });
  }

  Future<List<Equipe>> buscarEquipeUmaVez(String uidDono) async {
    final snapshot = await _ref.child(uidDono).get();
    if (!snapshot.exists) return [];
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    return map.entries
        .map((e) => Equipe.fromMap(
            e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map)))
        .toList();
  }

  Future<String> adicionar(String uidDono, Equipe equipe) async {
    final novaRef = _ref.child(uidDono).push();
    final comId = Equipe(
      id: novaRef.key!,
      nome: equipe.nome,
      email: equipe.email,
      telefone: equipe.telefone,
      uid: uidDono,
      fotoUrl: equipe.fotoUrl,
    );
    await novaRef.set(comId.toMap());
    return novaRef.key!;
  }

  Future<void> atualizar(String uidDono, Equipe equipe) {
    return _ref.child(uidDono).child(equipe.id).set(equipe.toMap());
  }

  Future<void> excluir(String uidDono, String idMembro) {
    return _ref.child(uidDono).child(idMembro).remove();
  }

  /// Remove a lista de equipe inteira do usuário (usado na exclusão de conta).
  Future<void> excluirTodaEquipe(String uidDono) {
    return _ref.child(uidDono).remove();
  }
}
