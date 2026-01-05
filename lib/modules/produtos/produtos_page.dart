import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'produtos_controller.dart';
import '../../models/produto_model.dart';
import 'produto_form_page.dart';

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProdutosController()..ouvirProdutos(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Produtos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProdutoFormPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<ProdutosController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.produtos.isEmpty) {
              return const Center(
                child: Text('Nenhum produto cadastrado'),
              );
            }

            return ListView.builder(
              itemCount: controller.produtos.length,
              itemBuilder: (context, index) {
                final ProdutoModel produto = controller.produtos[index];
                final bool estoqueBaixo = produto.quantidade <= 3;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: estoqueBaixo ? Colors.red.shade50 : null,
                  child: ListTile(
                    title: Text(produto.nome),
                    subtitle: Text(
                      'Estoque: ${produto.quantidade}',
                      style: TextStyle(
                        color: estoqueBaixo ? Colors.red : null,
                        fontWeight:
                            estoqueBaixo ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProdutoFormPage(
                                produto: produto,
                              ),
                            ),
                          );
                        } else if (value == 'excluir') {
                          controller.excluirProduto(produto.id);
                        }
                      },
                      itemBuilder: (context) => const [
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
