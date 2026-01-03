import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';
import 'cliente_form_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _clienteService = ClienteService();

  void _novoCliente() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClienteFormPage()),
    );
    setState(() {});
  }

  Future<void> _abrirWhatsApp(String telefone) async {
    final numero = telefone.replaceAll(RegExp(r'\D'), '');

    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telefone inválido')),
      );
      return;
    }

    final uri = Uri.parse('https://wa.me/55$numero');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientes = _clienteService.listar();

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _novoCliente,
        child: const Icon(Icons.add),
      ),
      body: clientes.isEmpty
          ? const Center(child: Text('Nenhum cliente cadastrado'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (_, index) {
                final ClienteModel cliente = clientes[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(cliente.nome),
                    subtitle: Text(cliente.telefone),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.chat,
                        color:Colors.green,
                      ),
                      tooltip: 'Abrir WhatsApp',
                      onPressed: () =>
                          _abrirWhatsApp(cliente.telefone),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
