import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cliente_model.dart';

class ClienteService {
  final _collection =
      FirebaseFirestore.instance.collection('clientes');

  Stream<List<ClienteModel>> listar() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ClienteModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> adicionar(String nome, String telefone) async {
    await _collection.add({
      'nome': nome,
      'telefone': telefone,
    });
  }

  Future<void> atualizar(ClienteModel cliente) async {
    await _collection.doc(cliente.id).update(cliente.toMap());
  }

  Future<void> remover(String id) async {
    await _collection.doc(id).delete();
  }
}
