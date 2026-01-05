import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cliente_model.dart';

class ClienteService {
  final _db = FirebaseFirestore.instance.collection('clientes');

  Stream<List<ClienteModel>> listar() {
    return _db.snapshots().map(
          (s) => s.docs
              .map((d) => ClienteModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> criar(ClienteModel cliente) async {
    await _db.add(cliente.toMap());
  }

  Future<void> atualizar(ClienteModel cliente) async {
    await _db.doc(cliente.id).update(cliente.toMap());
  }

  Future<void> remover(String id) async {
    await _db.doc(id).delete();
  }
}
