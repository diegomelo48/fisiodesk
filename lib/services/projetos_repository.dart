import 'package:firebase_database/firebase_database.dart';
import '../models/projeto.dart';

/// Equivalente a `FirebaseDatabase.getInstance().getReference("projetos")`,
/// usado em HomeFragment, ProjetosEtapasFragment, NovoProjetoActivity,
/// DetalhesProjetoEtapaActivity e ProjetoAdapter.
class ProjetosRepository {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('projetos');

  /// Busca (uma vez) os projetos do usuário logado, igual ao
  /// addListenerForSingleValueEvent + filtro por uid feito nos Fragments.
  Future<List<Projeto>> buscarMeusProjetos(String uid) async {
    final snapshot = await _ref.get();
    if (!snapshot.exists) return [];
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    return map.entries
        .map((e) => Projeto.fromMap(
            e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map)))
        .where((p) => p.uid == uid)
        .toList();
  }

  Future<Projeto?> buscarPorId(String id) async {
    final snapshot = await _ref.child(id).get();
    if (!snapshot.exists) return null;
    return Projeto.fromMap(
        id, Map<dynamic, dynamic>.from(snapshot.value as Map));
  }

  Future<String> criar(Projeto projeto) async {
    final novaRef = _ref.push();
    final mapa = projeto.toMap()..['id'] = novaRef.key;
    await novaRef.set(mapa);
    return novaRef.key!;
  }

  Future<void> atualizar(Projeto projeto) {
    return _ref.child(projeto.id).set(projeto.toMap());
  }

  Future<void> excluir(String id) {
    return _ref.child(id).remove();
  }
}
