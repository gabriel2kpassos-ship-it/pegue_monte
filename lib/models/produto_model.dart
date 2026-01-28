class ProdutoModel {
  final String id;
  final String nome;
  final int quantidade;
  final String? fotoUrl;

  /// ✅ necessário pra apagar no Cloudinary
  final String? fotoPublicId;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.fotoUrl,
    this.fotoPublicId,
  });

  factory ProdutoModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProdutoModel(
      id: id,
      nome: data['nome'] ?? '',
      quantidade: data['quantidade'] ?? 0,
      fotoUrl: data['fotoUrl'],
      fotoPublicId: data['fotoPublicId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'fotoUrl': fotoUrl,
      'fotoPublicId': fotoPublicId,
    };
  }

  ProdutoModel copyWith({
    String? id,
    String? nome,
    int? quantidade,
    String? fotoUrl,
    String? fotoPublicId,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fotoPublicId: fotoPublicId ?? this.fotoPublicId,
    );
  }
}
