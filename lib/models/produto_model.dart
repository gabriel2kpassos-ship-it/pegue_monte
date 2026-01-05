class ProdutoModel {
  final String id;
  final String nome;
  final int quantidade;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.quantidade,
  });

  factory ProdutoModel.fromMap(String id, Map<String, dynamic> map) {
    return ProdutoModel(
      id: id,
      nome: map['nome'],
      quantidade: map['quantidade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
    };
  }
}
