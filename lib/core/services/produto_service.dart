import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/produto_model.dart';

class ProdutoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _produtos =>
      _firestore.collection('produtos');

  /// LISTAR PRODUTOS
  Stream<List<ProdutoModel>> listarProdutos() {
    return _produtos.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProdutoModel.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// BUSCAR PRODUTO POR ID (🔥 NECESSÁRIO PARA ALUGUEL)
  Future<ProdutoModel> buscarProdutoPorId(String id) async {
    final doc = await _produtos.doc(id).get();

    if (!doc.exists) {
      throw Exception('Produto não encontrado');
    }

    return ProdutoModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  /// CRIAR PRODUTO
  Future<void> criarProduto(ProdutoModel produto) async {
    await _produtos.add(produto.toFirestore());
  }

  /// ATUALIZAR PRODUTO
  Future<void> atualizarProduto(ProdutoModel produto) async {
    await _produtos.doc(produto.id).update(produto.toFirestore());
  }

  /// EXCLUIR PRODUTO
  Future<void> excluirProduto(String id) async {
    await _produtos.doc(id).delete();
  }
}
