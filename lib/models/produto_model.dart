class ProdutoModel {
  final String id;
  final String nome;
  final int estoque;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.estoque,
  });

  factory ProdutoModel.fromMap(String id, Map<String, dynamic> map) {
    return ProdutoModel(
      id: id,
      nome: map['nome'] as String,
      estoque: map['estoque'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'estoque': estoque,
    };
  }
}
