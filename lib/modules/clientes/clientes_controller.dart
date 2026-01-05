import 'package:flutter/material.dart';

import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';

class ClientesController extends ChangeNotifier {
  final ClienteService _service = ClienteService();

  List<ClienteModel> clientes = [];
  bool isLoading = false;

  void ouvirClientes() {
    isLoading = true;
    notifyListeners();

    _service.listarClientes().listen((lista) {
      clientes = lista;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> adicionarCliente(ClienteModel cliente) async {
    await _service.criarCliente(cliente);
  }

  Future<void> atualizarCliente(ClienteModel cliente) async {
    await _service.atualizarCliente(cliente);
  }

  Future<void> excluirCliente(String clienteId) async {
    await _service.excluirCliente(clienteId);
  }
}
