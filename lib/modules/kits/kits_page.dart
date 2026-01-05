import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'kits_controller.dart';
import 'kit_form_page.dart';
import '../../models/kit_model.dart';

class KitsPage extends StatelessWidget {
  const KitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KitsController()..ouvirKits(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kits'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const KitFormPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<KitsController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.kits.isEmpty) {
              return const Center(
                child: Text('Nenhum kit cadastrado'),
              );
            }

            return ListView.builder(
              itemCount: controller.kits.length,
              itemBuilder: (context, index) {
                final KitModel kit = controller.kits[index];

                return ListTile(
                  title: Text(kit.nome),
                  subtitle: Text(
                    'Itens: ${kit.itens.length} • '
                    'R\$ ${kit.preco.toStringAsFixed(2)}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KitFormPage(kit: kit),
                          ),
                        );
                      } else if (value == 'excluir') {
                        controller.excluirKit(kit.id);
                      }
                    },
                    itemBuilder: (_) => const [
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
