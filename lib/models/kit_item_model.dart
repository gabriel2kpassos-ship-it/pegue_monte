class KitItemModel {
  final String produtoId;
  final String produtoNome;
  final int quantidade;

  KitItemModel({
    required this.produtoId,
    required this.produtoNome,
    required this.quantidade,
  });

  KitItemModel copyWith({
    String? produtoId,
    String? produtoNome,
    int? quantidade,
  }) {
    return KitItemModel(
      produtoId: produtoId ?? this.produtoId,
      produtoNome: produtoNome ?? this.produtoNome,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory KitItemModel.fromMap(Map<String, dynamic> map) {
    return KitItemModel(
      produtoId: map['produtoId'] as String,
      produtoNome: map['produtoNome'] as String,
      quantidade: map['quantidade'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'produtoNome': produtoNome,
      'quantidade': quantidade,
    };
  }
}
