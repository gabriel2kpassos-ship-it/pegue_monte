enum AluguelStatus {
  ativo,
  devolvido,
}

class AluguelModel {
  final String id;

  final String clienteId;
  final String clienteNome;

  final String kitId;
  final String kitNome;

  final DateTime dataInicio;
  final DateTime dataFim;

  final double valorTotal;

  final AluguelStatus status;

  AluguelModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.kitId,
    required this.kitNome,
    required this.dataInicio,
    required this.dataFim,
    required this.valorTotal,
    required this.status,
  });

  /// 🔄 Firestore → Model (ROBUSTO)
  factory AluguelModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final statusString = data['status'];

    AluguelStatus statusFinal = AluguelStatus.ativo;

    if (statusString is String) {
      try {
        statusFinal = AluguelStatus.values.firstWhere(
          (e) => e.name == statusString,
        );
      } catch (_) {
        statusFinal = AluguelStatus.ativo;
      }
    }

    return AluguelModel(
      id: id,
      clienteId: data['clienteId'] ?? '',
      clienteNome: data['clienteNome'] ?? '',
      kitId: data['kitId'] ?? '',
      kitNome: data['kitNome'] ?? '',
      dataInicio: (data['dataInicio'] as dynamic).toDate(),
      dataFim: (data['dataFim'] as dynamic).toDate(),
      valorTotal: (data['valorTotal'] as num?)?.toDouble() ?? 0.0,
      status: statusFinal,
    );
  }

  /// 🔄 Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      'kitId': kitId,
      'kitNome': kitNome,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'valorTotal': valorTotal,
      'status': status.name, // 🔥 GARANTIDO
    };
  }
}
