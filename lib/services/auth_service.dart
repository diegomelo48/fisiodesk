import 'package:firebase_auth/firebase_auth.dart';

/// Encapsula o FirebaseAuth, equivalente ao uso direto de
/// `FirebaseAuth.getInstance()` espalhado pelas Activities originais
/// (LoginActivity, CadastroActivity, RecuperarSenhaActivity, MainActivity...).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get usuarioAtual => _auth.currentUser;
  String? get uidAtual => _auth.currentUser?.uid;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Equivalente a auth.signInWithEmailAndPassword(email, senha) em LoginActivity.
  Future<UserCredential> login(String email, String senha) {
    return _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  /// Equivalente a auth.createUserWithEmailAndPassword(email, senha) em CadastroActivity.
  Future<UserCredential> cadastrar(String email, String senha) {
    return _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  /// Equivalente a auth.sendPasswordResetEmail(email) em RecuperarSenhaActivity.
  Future<void> recuperarSenha(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  /// Equivalente a auth.getCurrentUser().updatePassword(novaSenha) em PerfilFragment.
  Future<void> atualizarSenha(String novaSenha) {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuário não autenticado');
    }
    return user.updatePassword(novaSenha);
  }

  /// Confirma a identidade do usuário com a senha atual. O Firebase exige
  /// "login recente" para operações sensíveis como excluir a conta.
  Future<void> reautenticar(String senha) {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw StateError('Usuário não autenticado');
    }
    final credencial =
        EmailAuthProvider.credential(email: user.email!, password: senha);
    return user.reauthenticateWithCredential(credencial);
  }

  /// Exclui o usuário do Firebase Authentication (definitivo).
  Future<void> excluirUsuario() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Usuário não autenticado');
    }
    return user.delete();
  }

  /// Equivalente a FirebaseAuth.getInstance().signOut() em MainActivity.logout().
  Future<void> logout() {
    return _auth.signOut();
  }

  /// Traduz os códigos de erro mais comuns do FirebaseAuth para mensagens em
  /// português, parecido com os Toasts genéricos do app original.
  static String mensagemErro(Object erro) {
    if (erro is FirebaseAuthException) {
      switch (erro.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou senha inválidos.';
        case 'email-already-in-use':
          return 'Este email já está cadastrado.';
        case 'weak-password':
          return 'Senha muito fraca.';
        case 'invalid-email':
          return 'Email inválido.';
        case 'requires-recent-login':
          return 'Por segurança, saia e entre novamente antes de excluir a conta.';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
        case 'network-request-failed':
          return 'Sem conexão. Verifique sua internet e tente novamente.';
        default:
          return 'Erro: ${erro.message ?? erro.code}';
      }
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
