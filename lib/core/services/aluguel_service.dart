import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/aluguel_model.dart';
import 'produto_service.dart';
import 'kit_service.dart';

class AluguelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProdutoService _produtoService = ProdutoService();
  final KitService _kitService = KitService();

  CollectionReference get _alugueis => _firestore.collection('alugueis');

  /// 🔥 LISTAR ALUGUÉIS (STREAM FUNCIONAL – SEM orderBy)
  Stream<List<AluguelModel>> listarAlugueis() {
    return _alugueis.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AluguelModel.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// CRIAR ALUGUEL
  Future<void> criarAluguel(AluguelModel aluguel) async {
    // 🔒 validar estoque do kit
    final kit = await _kitService.buscarKitPorId(aluguel.kitId);

    for (final item in kit.itens) {
      final produto = await _produtoService.buscarProdutoPorId(item.produtoId);

      if (produto.quantidade < item.quantidade) {
        throw Exception('Estoque insuficiente para ${produto.nome}');
      }
    }

    // 🔻 debitar estoque
    for (final item in kit.itens) {
      final produto = await _produtoService.buscarProdutoPorId(item.produtoId);

      await _produtoService.atualizarProduto(
        produto.copyWith(
          quantidade: produto.quantidade - item.quantidade,
        ),
      );
    }

    await _alugueis.add(aluguel.toFirestore());
  }

  /// DEVOLVER ALUGUEL
  Future<void> devolverAluguel(String aluguelId) async {
    final doc = await _alugueis.doc(aluguelId).get();
    if (!doc.exists) return;

    final aluguel = AluguelModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );

    final kit = await _kitService.buscarKitPorId(aluguel.kitId);

    // 🔺 devolver estoque
    for (final item in kit.itens) {
      final produto = await _produtoService.buscarProdutoPorId(item.produtoId);

      await _produtoService.atualizarProduto(
        produto.copyWith(
          quantidade: produto.quantidade + item.quantidade,
        ),
      );
    }

    await _alugueis.doc(aluguelId).update({
      'status': AluguelStatus.devolvido.name,
    });
  }
}
