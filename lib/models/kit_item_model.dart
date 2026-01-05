class KitItemModel {
  final String produtoId;
  final String produtoNome;
  final int quantidade;

  KitItemModel({
    required this.produtoId,
    required this.produtoNome,
    required this.quantidade,
  });

  factory KitItemModel.fromMap(Map<String, dynamic> map) {
    return KitItemModel(
      produtoId: map['produtoId'],
      produtoNome: map['produtoNome'],
      quantidade: map['quantidade'],
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
