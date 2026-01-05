import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuário atual
  User? get currentUser => _auth.currentUser;

  /// Usuários permitidos no sistema
  static const Map<String, String> _allowedUsers = {
    'miriandaniela13': 'mirian@peguemonte.com',
    'geisimara': 'geisimara@peguemonte.com',
  };

  /// Login com NOME DE USUÁRIO + SENHA
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();

    if (password.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-password',
        message: 'Senha obrigatória',
      );
    }

    if (!_allowedUsers.containsKey(normalizedUsername)) {
      throw FirebaseAuthException(
        code: 'invalid-username',
        message: 'Usuário não autorizado',
      );
    }

    final email = _allowedUsers[normalizedUsername]!;

    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
