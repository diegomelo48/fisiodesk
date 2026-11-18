import 'auth_service.dart';
import 'equipe_repository.dart';
import 'etapas_repository.dart';
import 'projetos_repository.dart';
import 'storage_service.dart';
import 'usuarios_repository.dart';

/// Exclusão definitiva da conta, exigida pela App Store (diretriz 5.1.1(v)).
///
/// Ordem das operações (importante):
///  1. Reautentica com a senha. Se a senha estiver errada, falha aqui e
///     NADA é apagado.
///  2. Apaga os dados do usuário no Realtime Database e no Storage. Isso vem
///     antes de apagar o login porque as regras do banco normalmente exigem
///     usuário autenticado para escrever/remover.
///  3. Por último, exclui o usuário do Firebase Authentication.
class ContaService {
  final _auth = AuthService();
  final _usuarios = UsuariosRepository();
  final _projetos = ProjetosRepository();
  final _etapas = EtapasRepository();
  final _equipe = EquipeRepository();
  final _storage = StorageService();

  Future<void> excluirConta({required String senha}) async {
    final uid = _auth.uidAtual;
    if (uid == null) throw StateError('Usuário não autenticado');

    // 1) Confirma identidade.
    await _auth.reautenticar(senha);

    // 2a) Etapas: as criadas pelo usuário + as de projetos dele.
    final meusProjetos = await _projetos.buscarMeusProjetos(uid);
    final idsEtapas = <String>{};
    for (final etapa in await _etapas.buscarMinhasEtapas(uid)) {
      idsEtapas.add(etapa.id);
    }
    for (final projeto in meusProjetos) {
      for (final etapa in await _etapas.buscarPorProjeto(projeto.id)) {
        idsEtapas.add(etapa.id);
      }
    }
    for (final id in idsEtapas) {
      await _etapas.excluir(id);
    }

    // 2b) Projetos.
    for (final projeto in meusProjetos) {
      await _projetos.excluir(projeto.id);
    }

    // 2c) Equipe (registros + fotos).
    final equipe = await _equipe.buscarEquipeUmaVez(uid);
    for (final membro in equipe) {
      await _storage.excluirPorUrl(membro.fotoUrl);
    }
    await _equipe.excluirTodaEquipe(uid);

    // 2d) Perfil (registro + foto).
    await _storage.excluirFotoPerfil(uid);
    await _usuarios.excluir(uid);

    // 3) Remove o login. Também encerra a sessão neste aparelho.
    await _auth.excluirUsuario();
  }
}
