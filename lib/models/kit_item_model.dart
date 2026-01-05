class KitItemModel {
  final String produtoId;
  final String nome;
  final int quantidade;

  KitItemModel({
    required this.produtoId,
    required this.nome,
    required this.quantidade,
  });

  factory KitItemModel.fromMap(Map<String, dynamic> map) {
    return KitItemModel(
      produtoId: map['produtoId'] ?? '',
      nome: map['nome'] ?? '',
      quantidade: map['quantidade'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'nome': nome,
      'quantidade': quantidade,
    };
  }
}
