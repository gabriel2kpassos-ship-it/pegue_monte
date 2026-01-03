import 'package:flutter/material.dart';

import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';
import 'aluguel_form_page.dart';

class AlugueisPage extends StatefulWidget {
  const AlugueisPage({super.key});

  @override
  State<AlugueisPage> createState() => _AlugueisPageState();
}

class _AlugueisPageState extends State<AlugueisPage> {
  final service = AluguelService();

  Future<void> confirmarDevolucao(AluguelModel aluguel) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar devolução'),
        content: const Text(
          'Deseja realmente finalizar este aluguel e devolver os itens ao estoque?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await service.finalizarAluguel(aluguel);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aluguéis')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AluguelFormPage()),
          );
          if (result == true) setState(() {});
        },
      ),
      body: FutureBuilder<List<AluguelModel>>(
        future: service.listar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum aluguel'),
            );
          }

          final alugueis = snapshot.data!;

          return ListView.separated(
            itemCount: alugueis.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final aluguel = alugueis[index];
              final ativo =
                  aluguel.status == StatusAluguel.ativo;

              return ListTile(
                title: Text(aluguel.clienteNome),
                subtitle: Text(
                  '${aluguel.kitNome} • R\$ ${aluguel.valor.toStringAsFixed(2)}',
                ),
                trailing: ativo
                    ? ElevatedButton(
                        onPressed: () =>
                            confirmarDevolucao(aluguel),
                        child: const Text('Devolver'),
                      )
                    : const Chip(
                        label: Text('Finalizado'),
                        backgroundColor: Colors.green,
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
