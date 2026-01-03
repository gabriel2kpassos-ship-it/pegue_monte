import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/kit_model.dart';

class KitService {
  final _collection =
      FirebaseFirestore.instance.collection('kits');

  Future<void> salvar(KitModel kit) async {
    if (kit.id == null || kit.id!.isEmpty) {
      await _collection.add(kit.toMap());
    } else {
      await _collection.doc(kit.id).update(kit.toMap());
    }
  }
}
