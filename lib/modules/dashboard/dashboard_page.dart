import 'package:flutter/material.dart';
import '../clientes/clientes_page.dart';
import '../produtos/produtos_page.dart';
import '../kits/kits_page.dart';
import '../alugueis/alugueis_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pegue e Monte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _botao(context, 'Clientes', ClientesPage()),
          _botao(context, 'Produtos', ProdutosPage()),
          _botao(context, 'Kits', KitsPage()),
          _botao(context, 'Aluguéis', AlugueisPage()),
        ],
      ),
    );
  }

  Widget _botao(BuildContext context, String texto, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Text(texto),
      ),
    );
  }
}
