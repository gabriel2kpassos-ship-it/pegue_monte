import 'dart:math';
import '../../models/cliente_model.dart';

class ClientesController {
  static final List<ClienteModel> clientes = [];

  static void adicionar(ClienteModel cliente) {
    clientes.add(cliente);
  }

  static void atualizar(ClienteModel cliente) {
    final index = clientes.indexWhere((c) => c.id == cliente.id);

    if (index == -1) return; // evita crash

    clientes[index] = cliente;
  }

  static void remover(String id) {
    clientes.removeWhere((c) => c.id == id);
  }

  static String gerarId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);

    return '$timestamp$random';
  }
}
