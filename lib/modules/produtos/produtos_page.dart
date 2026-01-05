import 'package:flutter/material.dart';
import '../../models/produto_model.dart';
import 'produtos_controller.dart';

class ProdutosPage extends StatelessWidget {
  final _controller = ProdutosController();

  ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/produto-form');
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ProdutoModel>>(
        stream: _controller.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final produtos = snapshot.data!;

          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: produtos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final produto = produtos[index];

              return ListTile(
                title: Text(produto.nome),
                subtitle: Text('Quantidade: ${produto.quantidade}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/produto-form',
                          arguments: produto,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _controller.remover(produto.id);
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
