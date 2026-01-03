import '../../models/aluguel_model.dart';
import '../../models/kit_item_model.dart';
import 'produto_service.dart';

class AluguelService {
  AluguelService._internal();
  static final AluguelService _instance = AluguelService._internal();
  factory AluguelService() => _instance;

  final ProdutoService produtoService = ProdutoService();
  final List<AluguelModel> _alugueis = [];

  List<AluguelModel> listar() {
    return List.unmodifiable(_alugueis);
  }

  void adicionar(AluguelModel aluguel) {
    for (final item in aluguel.itens) {
      produtoService.baixarEstoque(item.produtoId, item.quantidade);
    }
    _alugueis.add(aluguel);
  }

  void finalizarAluguel(String aluguelId) {
    final index = _alugueis.indexWhere((a) => a.id == aluguelId);
    if (index < 0) return;

    final aluguel = _alugueis[index];
    if (aluguel.status == AluguelStatus.finalizado) return;

    for (final KitItemModel item in aluguel.itens) {
      produtoService.devolverEstoque(item.produtoId, item.quantidade);
    }

    _alugueis[index] =
        aluguel.copyWith(status: AluguelStatus.finalizado);
  }
}
