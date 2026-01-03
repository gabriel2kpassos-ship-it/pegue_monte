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
      appBar: AppBar(
        title: const Text('Pegue & Monte'),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'Clientes',
            icon: Icons.people,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientesPage()),
              );
            },
          ),
          _DashboardCard(
            title: 'Produtos',
            icon: Icons.inventory,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProdutosPage()),
              );
            },
          ),
          _DashboardCard(
            title: 'Kits',
            icon: Icons.widgets,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KitsPage()),
              );
            },
          ),
          _DashboardCard(
            title: 'Aluguéis',
            icon: Icons.assignment,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlugueisPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
