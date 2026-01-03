import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lista de usuários que você definiu
  final List<String> _usuariosValidos = ['mirian', 'geisimara'];

  Future<User?> login(String username, String password) async {
    try {
      String userLower = username.toLowerCase().trim();

      if (!_usuariosValidos.contains(userLower)) return null;

      // O Firebase exige um formato de e-mail, então completamos internamente
      String emailInterno = "$userLower@peguemonte.com";
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: emailInterno, 
        password: password.trim()
      );
      return result.user;
    } catch (e) {
      return null;
    }
  }
}