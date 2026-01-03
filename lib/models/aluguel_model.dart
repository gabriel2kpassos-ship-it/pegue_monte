enum AluguelStatus { ativo, finalizado }

class AluguelModel {
  final String id;
  final String clienteId;
  final String clienteNome;
  final String kitId;
  final String kitNome;
  final double kitPreco;
  final List itens;
  final DateTime dataInicio;
  final DateTime dataDevolucao;
  final AluguelStatus status;

  AluguelModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.kitId,
    required this.kitNome,
    required this.kitPreco,
    required this.itens,
    required this.dataInicio,
    required this.dataDevolucao,
    required this.status,
  });

  AluguelModel copyWith({
    String? id,
    String? clienteId,
    String? clienteNome,
    String? kitId,
    String? kitNome,
    double? kitPreco,
    List? itens,
    DateTime? dataInicio,
    DateTime? dataDevolucao,
    AluguelStatus? status,
  }) {
    return AluguelModel(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNome: clienteNome ?? this.clienteNome,
      kitId: kitId ?? this.kitId,
      kitNome: kitNome ?? this.kitNome,
      kitPreco: kitPreco ?? this.kitPreco,
      itens: itens ?? this.itens,
      dataInicio: dataInicio ?? this.dataInicio,
      dataDevolucao: dataDevolucao ?? this.dataDevolucao,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      'kitId': kitId,
      'kitNome': kitNome,
      'kitPreco': kitPreco,
      'itens': itens,
      'dataInicio': dataInicio.toIso8601String(),
      'dataDevolucao': dataDevolucao.toIso8601String(),
      'status': status.name,
    };
  }

  factory AluguelModel.fromMap(Map<String, dynamic> map) {
    return AluguelModel(
      id: map['id'],
      clienteId: map['clienteId'],
      clienteNome: map['clienteNome'],
      kitId: map['kitId'],
      kitNome: map['kitNome'],
      kitPreco: (map['kitPreco'] as num).toDouble(),
      itens: map['itens'],
      dataInicio: DateTime.parse(map['dataInicio']),
      dataDevolucao: DateTime.parse(map['dataDevolucao']),
      status: AluguelStatus.values
          .firstWhere((e) => e.name == map['status']),
    );
  }
}
