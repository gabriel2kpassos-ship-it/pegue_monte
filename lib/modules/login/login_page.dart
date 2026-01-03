import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;

  void _entrar() async {
    setState(() => _loading = true);
    
    final user = await _authService.login(_userController.text, _passController.text);

    setState(() => _loading = false);

    if (user != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const DashboardPage())
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário ou senha inválidos")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pegue & Monte", 
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const SizedBox(height: 40),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: "Usuário", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _entrar,
                child: _loading ? const CircularProgressIndicator() : const Text("ENTRAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}