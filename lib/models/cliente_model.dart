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
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
    };
  }
}
