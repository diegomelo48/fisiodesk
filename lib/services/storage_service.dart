import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Equivalente ao uso de FirebaseStorage.getInstance().getReference("FotosPerfil")
/// em CadastroActivity e PerfilFragment.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> enviarFotoPerfil(String uid, File arquivo) async {
    final ref = _storage.ref('FotosPerfil').child('$uid.jpg');
    await ref.putFile(arquivo);
    return ref.getDownloadURL();
  }

  /// Equipe também usa fotos de perfil próprias (dialog_add_equipe.xml).
  Future<String> enviarFotoEquipe(String idMembro, File arquivo) async {
    final ref = _storage.ref('FotosEquipe').child('$idMembro.jpg');
    await ref.putFile(arquivo);
    return ref.getDownloadURL();
  }

  /// Apaga a foto de perfil do usuário. Se o arquivo não existir, ignora.
  Future<void> excluirFotoPerfil(String uid) async {
    try {
      await _storage.ref('FotosPerfil').child('$uid.jpg').delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  /// Apaga uma foto a partir da URL de download salva no banco (usado para as
  /// fotos de equipe). Se o arquivo não existir mais, ignora.
  Future<void> excluirPorUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    } on ArgumentError {
      // URL que não pertence ao Storage do projeto: nada a apagar.
    }
  }
}
