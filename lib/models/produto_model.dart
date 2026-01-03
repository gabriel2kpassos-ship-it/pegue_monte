class ProdutoModel {
  final String id;
  final String nome;
  final int estoque;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.estoque,
  });

  ProdutoModel copyWith({
    String? id,
    String? nome,
    int? estoque,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      estoque: estoque ?? this.estoque,
    );
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      estoque: map['estoque'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'estoque': estoque,
    };
  }
}
