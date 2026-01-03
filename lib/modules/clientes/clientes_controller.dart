import '../../models/cliente_model.dart';
import 'dart:math';

class ClientesController {
  static final List<ClienteModel> clientes = [];

  static void adicionar(ClienteModel cliente) {
    clientes.add(cliente);
  }

  static void atualizar(ClienteModel cliente) {
    final index = clientes.indexWhere((c) => c.id == cliente.id);
    clientes[index] = cliente;
  }

  static void remover(String id) {
    clientes.removeWhere((c) => c.id == id);
  }

  static String gerarId() {
    return Random().nextInt(999999).toString();
  }
}
