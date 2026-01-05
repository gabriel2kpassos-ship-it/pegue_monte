import 'package:flutter/material.dart';

import '../../core/services/kit_service.dart';
import '../../models/kit_model.dart';

class KitsController extends ChangeNotifier {
  final KitService _service = KitService();

  List<KitModel> kits = [];
  bool isLoading = false;

  void ouvirKits() {
    isLoading = true;
    notifyListeners();

    _service.listarKits().listen((lista) {
      kits = lista;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> adicionarKit(KitModel kit) async {
    await _service.criarKit(kit);
  }

  Future<void> atualizarKit(KitModel kit) async {
    await _service.atualizarKit(kit);
  }

  Future<void> excluirKit(String kitId) async {
    await _service.excluirKit(kitId);
  }
}
