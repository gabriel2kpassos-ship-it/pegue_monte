import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alugueis_controller.dart';
import 'aluguel_form_page.dart';
import '../../models/aluguel_model.dart';

class AlugueisPage extends StatelessWidget {
  const AlugueisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlugueisController()..ouvirAlugueis(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Aluguéis')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AluguelFormPage(),
              ),
            );
          },
        ),
        body: Consumer<AlugueisController>(
          builder: (_, controller, __) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.alugueis.isEmpty) {
              return const Center(child: Text('Nenhum aluguel encontrado'));
            }

            return ListView.builder(
              itemCount: controller.alugueis.length,
              itemBuilder: (_, i) {
                final aluguel = controller.alugueis[i];

                return ListTile(
                  title: Text(aluguel.clienteNome),
                  subtitle: Text(
                    '${aluguel.kitNome}\n'
                    '${_fmt(aluguel.dataInicio)} → ${_fmt(aluguel.dataFim)}',
                  ),
                  isThreeLine: true,
                  trailing: aluguel.status == AluguelStatus.ativo
                      ? IconButton(
                          icon: const Icon(Icons.assignment_turned_in),
                          onPressed: () =>
                              controller.devolverAluguel(aluguel),
                        )
                      : const Icon(Icons.check, color: Colors.green),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}
