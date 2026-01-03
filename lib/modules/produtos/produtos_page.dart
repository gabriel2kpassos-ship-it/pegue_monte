import 'package:flutter/material.dart';

import '../../models/produto_model.dart';
import 'produtos_controller.dart';
import 'produto_form_page.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final controller = ProdutosController();

  void _abrirFormulario([ProdutoModel? produto]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProdutoFormPage(produto: produto),
      ),
    );
    setState(() {});
  }

  void _remover(String id) {
    controller.remover(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto removido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtos = controller.listar();

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (_, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text('Estoque: ${produto.estoque}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _abrirFormulario(produto),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _remover(produto.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
