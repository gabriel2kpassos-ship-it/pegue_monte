import 'package:flutter/material.dart';

import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';
import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';
import '../../models/produto_model.dart';

class KitsPage extends StatefulWidget {
  const KitsPage({super.key});

  @override
  State<KitsPage> createState() => _KitsPageState();
}

class _KitsPageState extends State<KitsPage> {
  final kitService = KitService();
  final produtoService = ProdutoService();

  final nomeKitCtrl = TextEditingController();

  final Map<String, int> itensSelecionados = {};
  final Map<String, TextEditingController> qtdControllers = {};

  TextEditingController _getQtdController(String produtoId) {
    return qtdControllers.putIfAbsent(
      produtoId,
      () => TextEditingController(),
    );
  }

  @override
  void dispose() {
    nomeKitCtrl.dispose();
    for (final c in qtdControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kits')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomeKitCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nome do Kit'),
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<ProdutoModel>>(
                  stream: produtoService.listar(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                          'Nenhum produto cadastrado');
                    }

                    return Column(
                      children: snapshot.data!
                          .map((produto) =>
                              _produtoLinha(context, produto))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _salvarKit,
                  child: const Text('Salvar Kit'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<KitModel>>(
              stream: kitService.listar(),
              builder: (_, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum kit cadastrado'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) {
                    final kit = snapshot.data![i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(kit.nome),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: kit.itens.map((item) {
                            final produto = produtoService
                                .getById(item.produtoId);
                            return Text(
                              '${produto?.nome ?? 'Produto removido'} '
                              '- Qtd: ${item.quantidade}',
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _produtoLinha(BuildContext context, ProdutoModel produto) {
    final controller = _getQtdController(produto.id);

    return Row(
      children: [
        Expanded(
          child: Text('${produto.nome} (Estoque: ${produto.estoque})'),
        ),
        SizedBox(
          width: 70,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Qtd'),
            onChanged: (value) {
              final qtd = int.tryParse(value) ?? 0;

              if (qtd > produto.estoque) {
                controller.text = produto.estoque.toString();
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Acesso negado: quantidade maior que o estoque'),
                  ),
                );

                setState(() {
                  itensSelecionados[produto.id] = produto.estoque;
                });
                return;
              }

              setState(() {
                if (qtd > 0) {
                  itensSelecionados[produto.id] = qtd;
                } else {
                  itensSelecionados.remove(produto.id);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _salvarKit() async {
    if (nomeKitCtrl.text.isEmpty ||
        itensSelecionados.isEmpty) {
      return;
    }

    final kit = KitModel(
      id: '',
      nome: nomeKitCtrl.text,
      itens: itensSelecionados.entries
          .map(
            (e) => KitItemModel(
              produtoId: e.key,
              quantidade: e.value,
            ),
          )
          .toList(),
    );

    await kitService.adicionar(kit);

    nomeKitCtrl.clear();
    itensSelecionados.clear();

    for (final c in qtdControllers.values) {
      c.clear();
    }
    qtdControllers.clear();

    setState(() {});
  }
}
