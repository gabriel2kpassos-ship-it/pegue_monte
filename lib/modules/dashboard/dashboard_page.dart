import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';

import '../clientes/clientes_page.dart';
import '../produtos/produtos_page.dart';
import '../kits/kits_page.dart';
import '../alugueis/alugueis_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AluguelService>(
      create: (_) => AluguelService(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              actions: [
                IconButton(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<List<AluguelModel>>(
                stream:
                    context.read<AluguelService>().listarAlugueis(),
                builder: (context, snapshot) {
                  final alugueis = snapshot.data ?? [];
                  final ativos = alugueis
                      .where(
                        (a) => a.status == AluguelStatus.ativo,
                      )
                      .length;

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCard(
                        icon: Icons.people,
                        title: 'Clientes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClientesPage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.inventory_2,
                        title: 'Produtos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProdutosPage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.all_inbox,
                        title: 'Kits',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const KitsPage(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        icon: Icons.assignment,
                        title: 'Aluguéis Ativos ($ativos)',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AlugueisPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
