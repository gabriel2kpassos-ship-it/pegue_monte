import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/kit_model.dart';

class KitService {
  final _db = FirebaseFirestore.instance.collection('kits');

  Stream<List<KitModel>> listar() {
    return _db.snapshots().map(
          (s) => s.docs
              .map((d) => KitModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> criar(KitModel kit) async {
    await _db.add(kit.toMap());
  }

  Future<void> atualizar(KitModel kit) async {
    await _db.doc(kit.id).update(kit.toMap());
  }

  Future<void> remover(String id) async {
    await _db.doc(id).delete();
  }
}
