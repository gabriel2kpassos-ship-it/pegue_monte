import '../../models/cliente_model.dart';

class ClienteService {
  ClienteService._internal();
  static final ClienteService _instance = ClienteService._internal();
  factory ClienteService() => _instance;

  final List<ClienteModel> _clientes = [];

  List<ClienteModel> listar() {
    return List.unmodifiable(_clientes);
  }

  void adicionar(ClienteModel cliente) {
    _clientes.add(cliente);
  }

  void atualizar(ClienteModel cliente) {
    final index = _clientes.indexWhere((c) => c.id == cliente.id);
    if (index >= 0) {
      _clientes[index] = cliente;
    }
  }

  void remover(String id) {
    _clientes.removeWhere((c) => c.id == id);
  }

  ClienteModel? obterPorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
