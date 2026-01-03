import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/aluguel_model.dart';
import '../../models/kit_model.dart';

class AluguelService {
  final _aluguelCollection =
      FirebaseFirestore.instance.collection('alugueis');
  final _produtoCollection =
      FirebaseFirestore.instance.collection('produtos');

  Future<void> registrarAluguel({
    required AluguelModel aluguel,
    required KitModel kit,
  }) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async {
      // 1️⃣ Validar estoque
      for (var item in kit.itens) {
        final produtoRef =
            _produtoCollection.doc(item.produtoId);

        final produtoSnap =
            await transaction.get(produtoRef);

        final estoqueAtual =
            produtoSnap['estoque'] as int;

        if (estoqueAtual < item.quantidade) {
          throw Exception(
              'Estoque insuficiente para um ou mais produtos.');
        }
      }

      // 2️⃣ Baixar estoque
      for (var item in kit.itens) {
        final produtoRef =
            _produtoCollection.doc(item.produtoId);

        final produtoSnap =
            await transaction.get(produtoRef);

        final estoqueAtual =
            produtoSnap['estoque'] as int;

        transaction.update(produtoRef, {
          'estoque': estoqueAtual - item.quantidade,
        });
      }

      // 3️⃣ Registrar aluguel
      transaction.set(
        _aluguelCollection.doc(),
        aluguel.toMap(),
      );
    });
  }

  Stream<List<AluguelModel>> listar() {
    return _aluguelCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              AluguelModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
