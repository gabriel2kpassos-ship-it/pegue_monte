import 'package:flutter/material.dart';
import '../../models/kit_model.dart';
import 'kits_controller.dart';

class KitsPage extends StatelessWidget {
  final bool selecionar;
  final _controller = KitsController();

  KitsPage({
    super.key,
    this.selecionar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selecionar ? 'Selecionar Kit' : 'Kits'),
      ),
      floatingActionButton: selecionar
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/kit-form');
              },
              child: const Icon(Icons.add),
            ),
      body: StreamBuilder<List<KitModel>>(
        stream: _controller.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final kits = snapshot.data!;

          if (kits.isEmpty) {
            return const Center(child: Text('Nenhum kit cadastrado'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: kits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final kit = kits[index];

              return ListTile(
                title: Text(kit.nome),
                subtitle: Text('${kit.itens.length} itens'),

                /// 👉 SELEÇÃO DE KIT PARA ALUGUEL
                onTap: selecionar
                    ? () => Navigator.pop(context, kit)
                    : null,

                trailing: selecionar
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/kit-form',
                                arguments: kit,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _controller.remover(kit.id);
                            },
                          ),
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
