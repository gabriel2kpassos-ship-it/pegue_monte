import 'package:flutter/material.dart';

import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutosController extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<ProdutoModel> produtos = [];
  bool isLoading = false;

  void ouvirProdutos() {
    isLoading = true;
    notifyListeners();

    _service.listarProdutos().listen((lista) {
      produtos = lista;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> adicionarProduto(ProdutoModel produto) async {
    await _service.criarProduto(produto);
  }

  Future<void> atualizarProduto(ProdutoModel produto) async {
    await _service.atualizarProduto(produto);
  }

  Future<void> excluirProduto(String produtoId) async {
    await _service.excluirProduto(produtoId);
  }
}
