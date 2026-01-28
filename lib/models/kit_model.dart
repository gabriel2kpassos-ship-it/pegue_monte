import 'kit_item_model.dart';

class KitModel {
  final String id;
  final String nome;
  final double preco;
  final List<KitItemModel> itens;
  final String? fotoUrl;

  /// ✅ necessário pra apagar no Cloudinary
  final String? fotoPublicId;

  KitModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.itens,
    this.fotoUrl,
    this.fotoPublicId,
  });

  factory KitModel.fromFirestore(String id, Map<String, dynamic> data) {
    return KitModel(
      id: id,
      nome: data['nome'] ?? '',
      preco: (data['preco'] ?? 0).toDouble(),
      itens: (data['itens'] as List<dynamic>? ?? [])
          .map((e) => KitItemModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      fotoUrl: data['fotoUrl'],
      fotoPublicId: data['fotoPublicId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'preco': preco,
      'itens': itens.map((e) => e.toMap()).toList(),
      'fotoUrl': fotoUrl,
      'fotoPublicId': fotoPublicId,
    };
  }
}
