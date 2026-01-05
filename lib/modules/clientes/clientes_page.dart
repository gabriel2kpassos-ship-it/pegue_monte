import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/phone_display_formatter.dart';
import '../../models/cliente_model.dart';
import 'clientes_controller.dart';

class ClientesPage extends StatelessWidget {
  final bool selecionar;
  final _controller = ClientesController();

  ClientesPage({
    super.key,
    this.selecionar = false,
  });

  Future<void> _abrirWhatsApp(String telefone) async {
    final numero = telefone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://wa.me/55$numero');

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selecionar ? 'Selecionar Cliente' : 'Clientes'),
      ),
      floatingActionButton: selecionar
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cliente-form');
              },
              child: const Icon(Icons.add),
            ),
      body: StreamBuilder<List<ClienteModel>>(
        stream: _controller.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final clientes = snapshot.data!;

          if (clientes.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente cadastrado'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: clientes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final cliente = clientes[index];

              return ListTile(
                title: Text(cliente.nome),
                subtitle: Text(
                  PhoneDisplayFormatter.format(cliente.telefone),
                ),

                /// 👉 SELEÇÃO DE CLIENTE PARA ALUGUEL
                onTap: selecionar
                    ? () => Navigator.pop(context, cliente)
                    : null,

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// WhatsApp (mantido)
                    IconButton(
                      tooltip: 'WhatsApp',
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.green,
                      ),
                      onPressed: () =>
                          _abrirWhatsApp(cliente.telefone),
                    ),

                    /// Editar / Excluir SOMENTE no modo normal
                    if (!selecionar) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/cliente-form',
                            arguments: cliente,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _controller.remover(cliente.id);
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
