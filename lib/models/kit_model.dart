import 'kit_item_model.dart';

class KitModel {
  final String id;
  final String nome;
  final double preco;
  final List<KitItemModel> itens;

  KitModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.itens,
  });

  factory KitModel.fromMap(String id, Map<String, dynamic> map) {
    return KitModel(
      id: id,
      nome: map['nome'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map(
            (e) => KitItemModel.fromMap(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'preco': preco,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }
}
