import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';
import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';

class KitsController {
  final KitService _kitService = KitService();
  final ProdutoService _produtoService = ProdutoService();

  List<KitModel> listar() {
    return _kitService.listar();
  }

  void salvar(KitModel kit) {
    final existente = _kitService.obterPorId(kit.id);
    if (existente == null) {
      _kitService.adicionar(kit);
    } else {
      _kitService.atualizar(kit);
    }
  }

  void remover(String id) {
    _kitService.remover(id);
  }

  bool podeAdicionarItem(String produtoId, int quantidade) {
    return _produtoService.temEstoque(produtoId, quantidade);
  }

  ProdutoService get produtoService => _produtoService;

  KitItemModel criarItem({
    required String produtoId,
    required String produtoNome,
    required int quantidade,
  }) {
    return KitItemModel(
      produtoId: produtoId,
      produtoNome: produtoNome,
      quantidade: quantidade,
    );
  }
}
