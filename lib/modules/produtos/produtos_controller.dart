import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutosController {
  final ProdutoService _service = ProdutoService();

  List<ProdutoModel> listar() {
    return _service.listar();
  }

  void salvar(ProdutoModel produto) {
    final existente = _service.obterPorId(produto.id);
    if (existente == null) {
      _service.adicionar(produto);
    } else {
      _service.atualizar(produto);
    }
  }

  void remover(String id) {
    _service.remover(id);
  }

  ProdutoModel? obterPorId(String id) {
    return _service.obterPorId(id);
  }
}
