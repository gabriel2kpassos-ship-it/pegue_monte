class KitItemModel {
  final String produtoId;
  final int quantidade;

  KitItemModel({
    required this.produtoId,
    required this.quantidade,
  });

  factory KitItemModel.fromMap(Map<String, dynamic> map) {
    return KitItemModel(
      produtoId: map['produtoId'] as String,
      quantidade: map['quantidade'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'quantidade': quantidade,
    };
  }
}
