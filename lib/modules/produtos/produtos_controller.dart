import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutosController {
  final _service = ProdutoService();

  Stream<List<ProdutoModel>> listar() {
    return _service.listar();
  }

  Future<void> remover(String id) async {
    await _service.remover(id);
  }
}
