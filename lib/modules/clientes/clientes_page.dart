import 'package:flutter/material.dart';
import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';

class ClientesPage extends StatelessWidget {
  final service = ClienteService();
  final nomeCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();

  ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: telefoneCtrl,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nomeCtrl.text.isEmpty ||
                        telefoneCtrl.text.isEmpty) {
                      return;
                    }

                    service.adicionar(
                      nomeCtrl.text,
                      telefoneCtrl.text,
                    );

                    nomeCtrl.clear();
                    telefoneCtrl.clear();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ClienteModel>>(
              stream: service.listar(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!
                      .map(
                        (c) => ListTile(
                          title: Text(c.nome),
                          subtitle: Text(c.telefone),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
