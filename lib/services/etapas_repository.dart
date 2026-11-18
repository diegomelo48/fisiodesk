import 'package:firebase_database/firebase_database.dart';
import '../models/etapa.dart';

/// Equivalente a `FirebaseDatabase.getInstance().getReference("Etapas")`,
/// usado em HomeFragment, ProjetosEtapasFragment, NovaEtapaActivity,
/// EtapasActivity, DetalhesProjetoEtapaActivity e EtapaAdapter.
class EtapasRepository {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Etapas');

  Future<List<Etapa>> buscarMinhasEtapas(String uid) async {
    final snapshot = await _ref.get();
    if (!snapshot.exists) return [];
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    return map.entries
        .map((e) => Etapa.fromMap(
            e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map)))
        .where((et) => et.uid == uid)
        .toList();
  }

  /// Equivalente ao filtro `ref.orderByChild("uid").equalTo(uidAtual)` usado
  /// em ProjetosEtapasFragment (mesmo resultado, ignorando etapas sem idProjeto).
  Future<List<Etapa>> buscarMinhasEtapasComProjeto(String uid) async {
    final etapas = await buscarMinhasEtapas(uid);
    return etapas.where((e) => e.idProjeto.trim().isNotEmpty).toList();
  }

  Future<List<Etapa>> buscarPorProjeto(String idProjeto) async {
    final snapshot = await _ref.get();
    if (!snapshot.exists) return [];
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    return map.entries
        .map((e) => Etapa.fromMap(
            e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map)))
        .where((et) => et.idProjeto == idProjeto)
        .toList();
  }

  Future<Etapa?> buscarPorId(String id) async {
    final snapshot = await _ref.child(id).get();
    if (!snapshot.exists) return null;
    return Etapa.fromMap(id, Map<dynamic, dynamic>.from(snapshot.value as Map));
  }

  Future<String> criar(Etapa etapa) async {
    final novaRef = _ref.push();
    final mapa = etapa.toMap()..['id'] = novaRef.key;
    await novaRef.set(mapa);
    return novaRef.key!;
  }

  Future<void> atualizar(Etapa etapa) {
    return _ref.child(etapa.id).set(etapa.toMap());
  }

  Future<void> excluir(String id) {
    return _ref.child(id).remove();
  }

  /// Retorna um mapa idProjeto -> nomeProjeto, usado para popular
  /// txtNomeProjeto no EtapaAdapter (com cache).
  Future<String?> buscarNomeProjeto(String idProjeto) async {
    final snapshot =
        await FirebaseDatabase.instance.ref('projetos').child(idProjeto).get();
    if (!snapshot.exists) return null;
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    return map['nomeProjeto'] as String?;
  }
}
