import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      await _authService.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      // Se você for navegar para outra tela após login, faça aqui:
      // if (!mounted) return;
      // Navigator.of(context).pushReplacement(...);
    } catch (e) {
      // Se a tela já foi descartada enquanto aguardava o login, não tente usar context.
      if (!mounted) return;

      String message = 'Erro ao fazer login';

      final errorText = e.toString();
      if (errorText.contains('invalid-username')) {
        message = 'Usuário não autorizado';
      } else if (errorText.contains('wrong-password')) {
        message = 'Senha incorreta';
      } else if (errorText.contains('user-not-found')) {
        message = 'Usuário não encontrado';
      } else if (errorText.contains('empty-password')) {
        message = 'Informe a senha';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.lock_outline,
                size: 72,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),

              /// USUÁRIO
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                ),
              ),

              const SizedBox(height: 16),

              /// SENHA
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
              ),

              const SizedBox(height: 24),

              /// BOTÃO LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
