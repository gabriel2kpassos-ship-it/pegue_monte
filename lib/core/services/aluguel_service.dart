import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/aluguel_model.dart';
import '../../models/produto_model.dart';

class AluguelService {
  final _alugueis =
      FirebaseFirestore.instance.collection('alugueis');
  final _produtos =
      FirebaseFirestore.instance.collection('produtos');

  /// LISTAR
  Future<List<AluguelModel>> listar() async {
    final snap = await _alugueis.get();
    return snap.docs
        .map((d) => AluguelModel.fromMap(d.id, d.data()))
        .toList();
  }

  /// SALVAR + BAIXAR ESTOQUE
  Future<void> salvarComBaixaEstoque(
    AluguelModel aluguel,
    List<ProdutoModel> produtos,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    // salvar aluguel
    final aluguelRef = _alugueis.doc();
    batch.set(aluguelRef, aluguel.toMap());

    // baixar estoque
    for (final item in aluguel.itens) {
      final produto =
          produtos.firstWhere((p) => p.id == item.produtoId);

      final novoEstoque =
          produto.quantidade - item.quantidade;

      if (novoEstoque < 0) {
        throw Exception(
            'Estoque insuficiente para ${produto.nome}');
      }

      batch.update(
        _produtos.doc(produto.id),
        {'quantidade': novoEstoque},
      );
    }

    await batch.commit();
  }

  /// FINALIZAR + DEVOLVER ESTOQUE
  Future<void> finalizarAluguel(AluguelModel aluguel) async {
    final batch = FirebaseFirestore.instance.batch();

    batch.update(
      _alugueis.doc(aluguel.id),
      {'status': StatusAluguel.finalizado.name},
    );

    for (final item in aluguel.itens) {
      batch.update(
        _produtos.doc(item.produtoId),
        {
          'quantidade':
              FieldValue.increment(item.quantidade),
        },
      );
    }

    await batch.commit();
  }
}
