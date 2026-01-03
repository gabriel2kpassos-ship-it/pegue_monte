import 'kit_item_model.dart';

class KitModel {
  final String id;
  final String nome;
  final List<KitItemModel> itens;

  KitModel({
    required this.id,
    required this.nome,
    required this.itens,
  });

  factory KitModel.fromMap(String id, Map<String, dynamic> map) {
    final itensRaw = map['itens'] as List<dynamic>? ?? [];

    return KitModel(
      id: id,
      nome: map['nome'] as String,
      itens: itensRaw
          .map((e) => KitItemModel.fromMap(
                e as Map<String, dynamic>,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }
}
