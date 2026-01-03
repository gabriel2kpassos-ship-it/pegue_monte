import 'package:flutter/material.dart';
import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutosPage extends StatelessWidget {
  final service = ProdutoService();
  final nomeCtrl = TextEditingController();
  final estoqueCtrl = TextEditingController();

  ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: estoqueCtrl,
                  decoration: const InputDecoration(labelText: 'Estoque'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    service.adicionar(
                      nomeCtrl.text,
                      int.parse(estoqueCtrl.text),
                    );
                    nomeCtrl.clear();
                    estoqueCtrl.clear();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ProdutoModel>>(
              stream: service.listar(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!
                      .map(
                        (p) => ListTile(
                          title: Text(p.nome),
                          subtitle: Text('Estoque: ${p.estoque}'),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
