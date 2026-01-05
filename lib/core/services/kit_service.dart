import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/kit_model.dart';

class KitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _kits => _firestore.collection('kits');

  /// OUVIR KITS
  Stream<List<KitModel>> listarKits() {
    return _kits.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => KitModel.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// 🔎 BUSCAR KIT POR ID (🔥 NECESSÁRIO PARA ALUGUEL)
  Future<KitModel> buscarKitPorId(String id) async {
    final doc = await _kits.doc(id).get();

    if (!doc.exists) {
      throw Exception('Kit não encontrado');
    }

    return KitModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  /// CRIAR KIT
  Future<void> criarKit(KitModel kit) async {
    await _kits.add(kit.toFirestore());
  }

  /// ATUALIZAR KIT
  Future<void> atualizarKit(KitModel kit) async {
    await _kits.doc(kit.id).update(kit.toFirestore());
  }

  /// EXCLUIR KIT
  Future<void> excluirKit(String id) async {
    await _kits.doc(id).delete();
  }
}
