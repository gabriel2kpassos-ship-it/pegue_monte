class AluguelModel {
  final String id;
  final String clienteId;
  final String kitId;
  final DateTime data;

  AluguelModel({
    required this.id,
    required this.clienteId,
    required this.kitId,
    required this.data,
  });

  factory AluguelModel.fromMap(String id, Map<String, dynamic> map) {
    return AluguelModel(
      id: id,
      clienteId: map['clienteId'] as String,
      kitId: map['kitId'] as String,
      data: DateTime.parse(map['data'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'kitId': kitId,
      'data': data.toIso8601String(),
    };
  }
}
