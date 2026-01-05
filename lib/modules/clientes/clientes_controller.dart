import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';

class ClientesController {
  final _service = ClienteService();

  Stream<List<ClienteModel>> listar() {
    return _service.listar();
  }

  Future<void> remover(String id) async {
    await _service.remover(id);
  }
}
