class ClienteModel {
  final String id;
  final String nome;
  final String telefone;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  ClienteModel copyWith({
    String? id,
    String? nome,
    String? telefone,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
    );
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }
}
