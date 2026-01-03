import 'package:flutter/material.dart';
import 'kit_form_page.dart';
import 'kits_controller.dart';

class KitsPage extends StatefulWidget {
  const KitsPage({super.key});

  @override
  State<KitsPage> createState() => _KitsPageState();
}

class _KitsPageState extends State<KitsPage> {
  void atualizarTela() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final kits = KitsController.kits;

    return Scaffold(
      appBar: AppBar(title: const Text('Kits')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KitFormPage()),
          );
          if (result == true) atualizarTela();
        },
        child: const Icon(Icons.add),
      ),
      body: kits.isEmpty
          ? const Center(child: Text('Nenhum kit cadastrado'))
          : ListView.separated(
              itemCount: kits.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final kit = kits[index];

                return ListTile(
                  title: Text(kit.nome),
                  subtitle:
                      Text('R\$ ${kit.preco.toStringAsFixed(2)}'),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KitFormPage(kit: kit),
                      ),
                    );
                    if (result == true) atualizarTela();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      KitsController.remover(kit.id!);
                      atualizarTela();
                    },
                  ),
                );
              },
            ),
    );
  }
}
