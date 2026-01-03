import 'package:flutter/material.dart';
import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';

class ClientesController extends ChangeNotifier {
  final ClienteService _service;

  List<ClienteModel> _clientes = [];
  List<ClienteModel> get clientes => _clientes;

  ClientesController(this._service) {
    _escutarClientes();
  }

  void _escutarClientes() {
    _service.listar().listen((lista) {
      _clientes = lista;
      notifyListeners();
    });
  }

  Future<void> adicionar(String nome, String telefone) async {
    await _service.adicionar(nome, telefone);
  }

  Future<void> atualizar(ClienteModel cliente) async {
    await _service.atualizar(cliente);
  }

  Future<void> remover(String id) async {
    await _service.remover(id);
  }
}
