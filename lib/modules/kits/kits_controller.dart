import '../../models/kit_model.dart';
import 'dart:math';

class KitsController {
  static final List<KitModel> kits = [];

  static void adicionar(KitModel kit) {
    kits.add(kit);
  }

  static void atualizar(KitModel kit) {
    final index = kits.indexWhere((k) => k.id == kit.id);
    kits[index] = kit;
  }

  static void remover(String id) {
    kits.removeWhere((k) => k.id == id);
  }

  static String gerarId() {
    return Random().nextInt(999999).toString();
  }
}
