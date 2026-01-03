import 'package:flutter/material.dart';
import 'produto_form_page.dart';
import 'produtos_controller.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  void atualizarTela() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final produtos = ProdutosController.produtos;

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProdutoFormPage()),
          );
          if (result == true) atualizarTela();
        },
        child: const Icon(Icons.add),
      ),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado'))
          : ListView.separated(
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final produto = produtos[index];

                return ListTile(
                  title: Text(produto.nome),
                  subtitle:
                      Text('Quantidade em estoque: ${produto.quantidade}'),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProdutoFormPage(produto: produto),
                      ),
                    );
                    if (result == true) atualizarTela();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ProdutosController.remover(produto.id);
                      atualizarTela();
                    },
                  ),
                );
              },
            ),
    );
  }
}
