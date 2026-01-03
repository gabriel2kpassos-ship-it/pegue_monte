import 'package:flutter/material.dart';

import '../../core/services/kit_service.dart';
import '../../models/kit_item_model.dart';
import '../../models/kit_model.dart';
import '../../models/produto_model.dart';
import '../produtos/produtos_controller.dart';

class KitFormPage extends StatefulWidget {
  final KitModel? kit;

  const KitFormPage({super.key, this.kit});

  @override
  State<KitFormPage> createState() => _KitFormPageState();
}

class _KitFormPageState extends State<KitFormPage> {
  late TextEditingController nomeController;
  late TextEditingController precoController;
  late List<KitItemModel> itens;
  bool salvando = false;

  @override
  void initState() {
    super.initState();
    nomeController =
        TextEditingController(text: widget.kit?.nome ?? '');
    precoController =
        TextEditingController(text: widget.kit?.preco.toString() ?? '');
    itens = List.from(widget.kit?.itens ?? []);
  }

  void adicionarProduto(ProdutoModel produto) {
    final quantidadeNoKit = itens
        .where((i) => i.produtoId == produto.id)
        .fold<int>(0, (s, i) => s + i.quantidade);

    if (quantidadeNoKit >= produto.quantidade) {
      _alerta('Estoque insuficiente (${produto.quantidade})');
      return;
    }

    final index =
        itens.indexWhere((i) => i.produtoId == produto.id);

    setState(() {
      if (index >= 0) {
        itens[index] =
            itens[index].copyWith(quantidade: itens[index].quantidade + 1);
      } else {
        itens.add(
          KitItemModel(
            produtoId: produto.id,
            produtoNome: produto.nome,
            quantidade: 1,
          ),
        );
      }
    });
  }

  void alterarQuantidade(KitItemModel item, int novaQtd) {
    if (novaQtd < 1) return;

    final produto = ProdutosController.produtos
        .firstWhere((p) => p.id == item.produtoId);

    if (novaQtd > produto.quantidade) {
      _alerta('Estoque disponível: ${produto.quantidade}');
      return;
    }

    setState(() {
      final index = itens.indexOf(item);
      itens[index] = item.copyWith(quantidade: novaQtd);
    });
  }

  Future<void> salvar() async {
    if (salvando) return;

    if (nomeController.text.trim().isEmpty) {
      _alerta('Informe o nome do kit');
      return;
    }

    final preco = double.tryParse(precoController.text);

    if (preco == null || preco < 0) {
      _alerta('Informe um preço válido');
      return;
    }

    if (itens.isEmpty) {
      _alerta('Adicione pelo menos um produto');
      return;
    }

    setState(() => salvando = true);

    try {
      final kit = KitModel(
        id: widget.kit?.id,
        nome: nomeController.text.trim(),
        preco: preco,
        itens: itens,
      );

      await KitService().salvar(kit);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _alerta('Erro ao salvar kit\n$e');
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  void _alerta(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration:
                  const InputDecoration(labelText: 'Nome do Kit'),
            ),
            TextField(
              controller: precoController,
              decoration:
                  const InputDecoration(labelText: 'Preço do Kit'),
              keyboardType: TextInputType.number,
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  const Text('Produtos'),
                  ...ProdutosController.produtos.map(
                    (p) => ListTile(
                      title: Text(p.nome),
                      subtitle:
                          Text('Estoque: ${p.quantidade}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => adicionarProduto(p),
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text('Itens do Kit'),
                  ...itens.map(
                    (i) => ListTile(
                      title: Text(i.produtoNome),
                      subtitle: Text('Qtd: ${i.quantidade}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                alterarQuantidade(i, i.quantidade - 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                alterarQuantidade(i, i.quantidade + 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvando ? null : salvar,
                child: salvando
                    ? const CircularProgressIndicator()
                    : const Text('Salvar Kit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
