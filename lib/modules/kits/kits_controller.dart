import '../../core/services/kit_service.dart';
import '../../models/kit_model.dart';

class KitsController {
  final _service = KitService();

  Stream<List<KitModel>> listar() {
    return _service.listar();
  }

  Future<void> remover(String id) async {
    await _service.remover(id);
  }
}
