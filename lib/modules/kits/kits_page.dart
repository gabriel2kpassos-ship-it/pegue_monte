import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/kit_model.dart';
import 'kits_controller.dart';
import 'kit_form_page.dart';

class KitsPage extends StatefulWidget {
  const KitsPage({super.key});

  @override
  State<KitsPage> createState() => _KitsPageState();
}

class _KitsPageState extends State<KitsPage> {
  final controller = KitsController();

  final _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  void _abrirFormulario([KitModel? kit]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KitFormPage(kit: kit),
      ),
    );
    setState(() {});
  }

  void _remover(String id) {
    controller.remover(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kit removido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kits = controller.listar();

    return Scaffold(
      appBar: AppBar(title: const Text('Kits')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: kits.isEmpty
          ? const Center(child: Text('Nenhum kit cadastrado'))
          : ListView.builder(
              itemCount: kits.length,
              itemBuilder: (_, index) {
                final kit = kits[index];
                return ListTile(
                  title: Text(kit.nome),
                  subtitle: Text(
                    'Preço: ${_currencyFormat.format(kit.preco)} • '
                    'Itens: ${kit.itens.length}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _abrirFormulario(kit),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _remover(kit.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
