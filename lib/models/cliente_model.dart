class ClienteModel {
  final String id;
  final String nome;
  final String telefone;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  factory ClienteModel.fromMap(String id, Map<String, dynamic> map) {
    return ClienteModel(
      id: id,
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
    };
  }

  ClienteModel copyWith({
    String? nome,
    String? telefone,
  }) {
    return ClienteModel(
      id: id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
    );
  }
}
