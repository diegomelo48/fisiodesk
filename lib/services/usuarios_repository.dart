import 'package:firebase_database/firebase_database.dart';
import '../models/usuario.dart';

/// Equivalente a `FirebaseDatabase.getInstance().getReference("Usuarios")`,
/// usado em CadastroActivity e PerfilFragment.
class UsuariosRepository {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref('Usuarios');

  Future<void> salvar(Usuario usuario) {
    return _ref.child(usuario.uid).set(usuario.toMap());
  }

  Future<Usuario?> buscar(String uid) async {
    final snapshot = await _ref.child(uid).get();
    if (!snapshot.exists) return null;
    return Usuario.fromMap(Map<dynamic, dynamic>.from(snapshot.value as Map));
  }

  Future<void> excluir(String uid) {
    return _ref.child(uid).remove();
  }
}
