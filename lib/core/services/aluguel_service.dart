import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/aluguel_model.dart';
import '../../models/kit_model.dart';

class AluguelService {
  final _db = FirebaseFirestore.instance;

  /// ===============================
  /// CRIAR ALUGUEL COM VALIDAÇÃO
  /// ===============================
  Future<void> criar(AluguelModel aluguel) async {
    final batch = _db.batch();

    // 🔍 VALIDAR ESTOQUE
    for (final item in aluguel.kit.itens) {
      final produtoRef =
          _db.collection('produtos').doc(item.produtoId);

      final produtoSnap = await produtoRef.get();

      if (!produtoSnap.exists) {
        throw Exception('Produto não encontrado');
      }

      final estoqueAtual = produtoSnap['estoque'] as int;

      if (estoqueAtual < item.quantidade) {
        throw Exception(
          'quantidadeinsuficiente para o produto: ${item.nome}',
        );
      }
    }

    // 🧾 CRIAR ALUGUEL
    final aluguelRef = _db.collection('alugueis').doc();
    batch.set(aluguelRef, aluguel.toMap());

    // 📦 DAR BAIXA NO ESTOQUE
    for (final item in aluguel.kit.itens) {
      final produtoRef =
          _db.collection('produtos').doc(item.produtoId);

      batch.update(produtoRef, {
        'estoque': FieldValue.increment(-item.quantidade),
      });
    }

    await batch.commit();
  }

  /// ===============================
  /// FINALIZAR ALUGUEL (DEVOLVER)
  /// ===============================
  Future<void> finalizarAluguel(
    String aluguelId,
    KitModel kit,
  ) async {
    final batch = _db.batch();

    final aluguelRef =
        _db.collection('alugueis').doc(aluguelId);

    batch.update(aluguelRef, {
      'status': 'finalizado',
    });

    for (final item in kit.itens) {
      final produtoRef =
          _db.collection('produtos').doc(item.produtoId);

      batch.update(produtoRef, {
        'estoque': FieldValue.increment(item.quantidade),
      });
    }

    await batch.commit();
  }

  /// ===============================
  /// EXCLUIR ALUGUEL
  /// ===============================
  Future<void> excluir(String aluguelId) async {
    await _db.collection('alugueis').doc(aluguelId).delete();
  }

  /// ===============================
  /// LISTAR ALUGUÉIS
  /// ===============================
  Stream<List<AluguelModel>> listar() {
    return _db
        .collection('alugueis')
        .orderBy('dataRetirada')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AluguelModel.fromMap(doc.id, doc.data()),
              )
              .toList(),
        );
  }

  /// ===============================
  /// TOTAL DE ALUGUÉIS ATIVOS
  /// ===============================
  Stream<int> totalAtivos() {
    return _db
        .collection('alugueis')
        .where('status', isEqualTo: 'ativo')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
