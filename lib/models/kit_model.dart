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

  KitModel copyWith({
    String? id,
    String? nome,
    double? preco,
    List<KitItemModel>? itens,
  }) {
    return KitModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      itens: itens ?? this.itens,
    );
  }

  factory KitModel.fromMap(Map<String, dynamic> map) {
    return KitModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      preco: (map['preco'] as num).toDouble(),
      itens: (map['itens'] as List<dynamic>)
          .map((e) => KitItemModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }
}
