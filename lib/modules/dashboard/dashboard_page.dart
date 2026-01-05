import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/aluguel_service.dart';

class DashboardPage extends StatelessWidget {
  final _authService = AuthService();
  final _aluguelService = AluguelService();

  DashboardPage({super.key});

  void _logout(BuildContext context) async {
    await _authService.logout();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _card({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    Widget? subtitle,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                subtitle,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _alugueisAtivosCard(BuildContext context) {
    return StreamBuilder<int>(
      stream: _aluguelService.totalAtivos(),
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0;

        return _card(
          context: context,
          icon: Icons.event,
          title: 'Aluguéis',
          route: '/alugueis',
          subtitle: Text(
            '$total ativo(s)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: total > 0 ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _card(
              context: context,
              icon: Icons.people,
              title: 'Clientes',
              route: '/clientes',
            ),
            _card(
              context: context,
              icon: Icons.inventory_2,
              title: 'Produtos',
              route: '/produtos',
            ),
            _card(
              context: context,
              icon: Icons.widgets,
              title: 'Kits',
              route: '/kits',
            ),
            _alugueisAtivosCard(context),
          ],
        ),
      ),
    );
  }
}
