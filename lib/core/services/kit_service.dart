import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/kit_model.dart';
import 'cloudinary_service.dart';

class KitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinary = const CloudinaryService();

  CollectionReference get _kits => _firestore.collection('kits');

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

  Future<void> criarKit(KitModel kit) async {
    await _kits.add(kit.toFirestore());
  }

  Future<void> atualizarKit(KitModel kit) async {
    await _kits.doc(kit.id).update(kit.toFirestore());
  }

  /// ✅ Excluir kit + apagar imagem no Cloudinary
  Future<void> excluirKit(String id) async {
    final docRef = _kits.doc(id);
    final snap = await docRef.get();

    if (!snap.exists) return;

    final kit = KitModel.fromFirestore(
      snap.id,
      snap.data() as Map<String, dynamic>,
    );

    final publicId = kit.fotoPublicId;

    if (publicId != null && publicId.isNotEmpty) {
      await _cloudinary.deleteImage(publicId);
    }

    await docRef.delete();
  }
}
