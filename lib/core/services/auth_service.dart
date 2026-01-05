import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mapeamento de usuário -> email
  final Map<String, String> _usuarios = {
    'miriandaniela13': 'mirian@peguemonte.com',
    'geisimara': 'geisimara@peguemonte.com',
  };

  Future<User?> loginComUsuario({
    required String usuario,
    required String senha,
  }) async {
    final usuarioNormalizado = usuario.trim().toLowerCase();

    if (!_usuarios.containsKey(usuarioNormalizado)) {
      throw FirebaseAuthException(
        code: 'usuario-invalido',
        message: 'Usuário não encontrado',
      );
    }

    final email = _usuarios[usuarioNormalizado]!;

    final credencial = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );

    return credencial.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get usuarioAtual => _auth.currentUser;
}
