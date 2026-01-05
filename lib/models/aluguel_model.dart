import 'kit_model.dart';

class AluguelModel {
  final String id;
  final String clienteId;
  final String clienteNome;
  final KitModel kit;
  final DateTime dataRetirada;
  final DateTime dataDevolucao;
  final double valorTotal;
  final String status;

  AluguelModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.kit,
    required this.dataRetirada,
    required this.dataDevolucao,
    required this.valorTotal,
    required this.status,
  });

  factory AluguelModel.fromMap(String id, Map<String, dynamic> map) {
    return AluguelModel(
      id: id,
      clienteId: map['clienteId'],
      clienteNome: map['clienteNome'],
      kit: KitModel.fromMap(
        map['kit']['id'],
        Map<String, dynamic>.from(map['kit']),
      ),
      dataRetirada: DateTime.parse(map['dataRetirada']),
      dataDevolucao: DateTime.parse(map['dataDevolucao']),
      valorTotal: (map['valorTotal'] ?? 0).toDouble(),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      'kit': kit.toMap()..['id'] = kit.id,
      'dataRetirada': dataRetirada.toIso8601String(),
      'dataDevolucao': dataDevolucao.toIso8601String(),
      'valorTotal': valorTotal,
      'status': status,
    };
  }
}
