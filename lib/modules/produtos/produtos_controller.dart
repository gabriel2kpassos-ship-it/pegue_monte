import '../../models/produto_model.dart';
import 'dart:math';

class ProdutosController {
  static final List<ProdutoModel> produtos = [];

  static void adicionar(ProdutoModel produto) {
    produtos.add(produto);
  }

  static void atualizar(ProdutoModel produto) {
    final index = produtos.indexWhere((p) => p.id == produto.id);
    produtos[index] = produto;
  }

  static void remover(String id) {
    produtos.removeWhere((p) => p.id == id);
  }

  static String gerarId() {
    return Random().nextInt(999999).toString();
  }
}
