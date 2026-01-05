import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/cliente_model.dart';

class ClienteService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('clientes');

  /// Criar cliente
  Future<void> criarCliente(ClienteModel cliente) async {
    await _collection.add(cliente.toMap());
  }

  /// Atualizar cliente
  Future<void> atualizarCliente(ClienteModel cliente) async {
    await _collection.doc(cliente.id).update(cliente.toMap());
  }

  /// Excluir cliente
  Future<void> excluirCliente(String clienteId) async {
    await _collection.doc(clienteId).delete();
  }

  /// Listar clientes (stream)
  Stream<List<ClienteModel>> listarClientes() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ClienteModel.fromFirestore(doc))
              .toList(),
        );
  }
}
