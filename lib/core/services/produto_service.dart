import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/produto_model.dart';

class ProdutoService {
  final _db = FirebaseFirestore.instance;

  /// LISTAR PRODUTOS (COM quantidadeSEGURO)
  Stream<List<ProdutoModel>> listar() {
    return _db.collection('produtos').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();

            // 🔒 GARANTIR ESTOQUE
            data['estoque'] = data['estoque'] ?? 0;

            return ProdutoModel.fromMap(doc.id, data);
          }).toList(),
        );
  }

  /// CRIAR PRODUTO
  Future<void> criar(ProdutoModel produto) async {
    await _db.collection('produtos').add(produto.toMap());
  }

  /// ATUALIZAR PRODUTO
  Future<void> atualizar(ProdutoModel produto) async {
    await _db
        .collection('produtos')
        .doc(produto.id)
        .update(produto.toMap());
  }

  /// REMOVER PRODUTO
  Future<void> remover(String id) async {
    await _db.collection('produtos').doc(id).delete();
  }
}
