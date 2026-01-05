import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'clientes_controller.dart';
import '../../models/cliente_model.dart';
import 'cliente_form_page.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  void _abrirWhatsApp(String telefone) async {
    final uri = Uri.parse(
      'https://wa.me/55${telefone.replaceAll(RegExp(r"\\D"), "")}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientesController()..ouvirClientes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ClienteFormPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<ClientesController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.clientes.isEmpty) {
              return const Center(
                child: Text('Nenhum cliente cadastrado'),
              );
            }

            return ListView.builder(
              itemCount: controller.clientes.length,
              itemBuilder: (context, index) {
                final ClienteModel cliente = controller.clientes[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(cliente.nome),
                    subtitle: Text(cliente.telefone),
                    leading: IconButton(
                      icon: const Icon(Icons.chat, color: Colors.green),
                      onPressed: () => _abrirWhatsApp(cliente.telefone),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClienteFormPage(cliente: cliente),
                            ),
                          );
                        } else if (value == 'excluir') {
                          controller.excluirCliente(cliente.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
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
      ),
    );
  }
}
