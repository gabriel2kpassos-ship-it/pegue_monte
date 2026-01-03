import 'package:flutter/material.dart';
import 'cliente_form_page.dart';
import 'clientes_controller.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  void atualizarTela() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final clientes = ClientesController.clientes;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClienteFormPage()),
          );
          if (result == true) atualizarTela();
        },
        child: const Icon(Icons.add),
      ),
      body: clientes.isEmpty
          ? const Center(child: Text('Nenhum cliente cadastrado'))
          : ListView.separated(
              itemCount: clientes.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final cliente = clientes[index];

                return ListTile(
                  title: Text(cliente.nome),
                  subtitle: Text(cliente.telefone),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClienteFormPage(cliente: cliente),
                      ),
                    );
                    if (result == true) atualizarTela();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ClientesController.remover(cliente.id);
                      atualizarTela();
                    },
                  ),
                );
              },
            ),
    );
  }
}
