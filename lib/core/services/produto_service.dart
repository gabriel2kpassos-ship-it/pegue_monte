import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/produto_model.dart';
import 'cloudinary_service.dart';

class ProdutoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary = const CloudinaryService();

  CollectionReference get _produtos => _firestore.collection('produtos');

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

  Future<void> criarProduto(ProdutoModel produto) async {
    await _produtos.add(produto.toFirestore());
  }

  Future<void> atualizarProduto(ProdutoModel produto) async {
    await _produtos.doc(produto.id).update(produto.toFirestore());
  }

  /// ✅ Excluir produto + apagar imagem no Cloudinary
  Future<void> excluirProduto(String id) async {
    final docRef = _produtos.doc(id);
    final snap = await docRef.get();

    if (!snap.exists) return;

    final produto = ProdutoModel.fromFirestore(
      snap.id,
      snap.data() as Map<String, dynamic>,
    );

    final publicId = produto.fotoPublicId;

    // 1) Deleta imagem primeiro (se falhar, não apaga o Firestore -> você pode tentar de novo)
    if (publicId != null && publicId.isNotEmpty) {
      await _cloudinary.deleteImage(publicId);
    }

    // 2) Deleta documento no Firestore
    await docRef.delete();
  }
}
