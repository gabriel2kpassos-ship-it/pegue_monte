import '../../models/produto_model.dart';

class ProdutoService {
  ProdutoService._internal();
  static final ProdutoService _instance = ProdutoService._internal();
  factory ProdutoService() => _instance;

  final List<ProdutoModel> _produtos = [];

  List<ProdutoModel> listar() {
    return List.unmodifiable(_produtos);
  }

  void adicionar(ProdutoModel produto) {
    _produtos.add(produto);
  }

  void atualizar(ProdutoModel produto) {
    final index = _produtos.indexWhere((p) => p.id == produto.id);
    if (index >= 0) {
      _produtos[index] = produto;
    }
  }

  void remover(String id) {
    _produtos.removeWhere((p) => p.id == id);
  }

  ProdutoModel? obterPorId(String id) {
    try {
      return _produtos.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  bool temEstoque(String produtoId, int quantidade) {
    final produto = obterPorId(produtoId);
    if (produto == null) return false;
    return produto.estoque >= quantidade;
  }

  void baixarEstoque(String produtoId, int quantidade) {
    final produto = obterPorId(produtoId);
    if (produto == null) return;

    atualizar(produto.copyWith(
      estoque: produto.estoque - quantidade,
    ));
  }

  void devolverEstoque(String produtoId, int quantidade) {
    final produto = obterPorId(produtoId);
    if (produto == null) return;

    atualizar(produto.copyWith(
      estoque: produto.estoque + quantidade,
    ));
  }
}
