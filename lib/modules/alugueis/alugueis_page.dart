import 'package:flutter/material.dart';
import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';

class AlugueisPage extends StatelessWidget {
  final _service = AluguelService();

  Future<bool> _confirmar(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('Deseja realmente excluir este aluguel?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Excluir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aluguéis')),
      body: StreamBuilder<List<AluguelModel>>(
        stream: _service.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;

          if (lista.isEmpty) {
            return const Center(child: Text('Nenhum aluguel cadastrado'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final aluguel = lista[index];

              return Card(
                child: ListTile(
                  title: Text(aluguel.clienteNome),
                  subtitle: Text(
                    'Kit: ${aluguel.kit.nome}\nStatus: ${aluguel.status}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'finalizar') {
                        await _service.finalizarAluguel(
                          aluguel.id,
                          aluguel.kit,
                        );
                      } else if (v == 'excluir') {
                        if (await _confirmar(context)) {
                          await _service.excluir(aluguel.id);
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'finalizar',
                        child: Text('Finalizar'),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/aluguel-form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
