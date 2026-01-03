import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/produto_model.dart';

class ProdutoService {
  final _collection =
      FirebaseFirestore.instance.collection('produtos');

  final Map<String, ProdutoModel> cacheProdutos = {};

  Stream<List<ProdutoModel>> listar() {
    return _collection.snapshots().map((snapshot) {
      final produtos = snapshot.docs
          .map((doc) =>
              ProdutoModel.fromMap(doc.id, doc.data()))
          .toList();

      for (var p in produtos) {
        cacheProdutos[p.id] = p;
      }

      return produtos;
    });
  }

  ProdutoModel? getById(String id) {
    return cacheProdutos[id];
  }

  Future<void> adicionar(String nome, int estoque) async {
    await _collection.add({
      'nome': nome,
      'estoque': estoque,
    });
  }

  Future<void> atualizar(ProdutoModel produto) async {
    await _collection.doc(produto.id).update(produto.toMap());
  }

  Future<void> remover(String id) async {
    await _collection.doc(id).delete();
  }
}
