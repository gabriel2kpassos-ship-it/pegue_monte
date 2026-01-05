class ProdutoModel {
  final String id;
  final String nome;
  final int quantidade;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.quantidade,
  });

  /// 🔄 Firestore → Model
  factory ProdutoModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ProdutoModel(
      id: id,
      nome: data['nome'] ?? '',
      quantidade: data['quantidade'] ?? 0,
    );
  }

  /// 🔄 Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'quantidade': quantidade,
    };
  }

  /// 🔁 COPY WITH
  /// Necessário para controle de estoque (aluguel / devolução)
  ProdutoModel copyWith({
    String? id,
    String? nome,
    int? quantidade,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}
