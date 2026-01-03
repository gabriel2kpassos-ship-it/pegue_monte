import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/kit_model.dart';

class KitService {
  final _collection =
      FirebaseFirestore.instance.collection('kits');

  Stream<List<KitModel>> listar() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => KitModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> adicionar(KitModel kit) async {
    await _collection.add(kit.toMap());
  }

  Future<void> atualizar(KitModel kit) async {
    await _collection.doc(kit.id).update(kit.toMap());
  }

  Future<void> remover(String id) async {
    await _collection.doc(id).delete();
  }
}
