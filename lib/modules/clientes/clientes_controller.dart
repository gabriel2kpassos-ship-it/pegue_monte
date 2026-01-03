import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';

class ClientesController {
  final ClienteService _service = ClienteService();

  List<ClienteModel> listar() {
    return _service.listar();
  }

  void salvar(ClienteModel cliente) {
    final existente = _service.obterPorId(cliente.id);
    if (existente == null) {
      _service.adicionar(cliente);
    } else {
      _service.atualizar(cliente);
    }
  }

  void remover(String id) {
    _service.remover(id);
  }

  ClienteModel? obterPorId(String id) {
    return _service.obterPorId(id);
  }
}
