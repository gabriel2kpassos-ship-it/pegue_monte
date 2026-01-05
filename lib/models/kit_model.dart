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

  /// 🔄 Firestore → Model
  factory KitModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return KitModel(
      id: id,
      nome: data['nome'] ?? '',
      preco: (data['preco'] ?? 0).toDouble(),
      itens: (data['itens'] as List<dynamic>? ?? [])
          .map((e) => KitItemModel.fromMap(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
    );
  }

  /// 🔄 Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'preco': preco,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }
}
