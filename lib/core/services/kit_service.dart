import '../../models/kit_model.dart';

class KitService {
  KitService._internal();
  static final KitService _instance = KitService._internal();
  factory KitService() => _instance;

  final List<KitModel> _kits = [];

  List<KitModel> listar() {
    return List.unmodifiable(_kits);
  }

  void adicionar(KitModel kit) {
    _kits.add(kit);
  }

  void atualizar(KitModel kit) {
    final index = _kits.indexWhere((k) => k.id == kit.id);
    if (index >= 0) {
      _kits[index] = kit;
    }
  }

  void remover(String id) {
    _kits.removeWhere((k) => k.id == id);
  }

  KitModel? obterPorId(String id) {
    try {
      return _kits.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }
}
