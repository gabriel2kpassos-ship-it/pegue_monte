import 'kit_item_model.dart';

enum StatusAluguel { ativo, finalizado }

class AluguelModel {
  final String id;
  final String clienteId;
  final String clienteNome;
  final String kitId;
  final String kitNome;
  final double valor;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<KitItemModel> itens;
  final StatusAluguel status;

  AluguelModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    required this.kitId,
    required this.kitNome,
    required this.valor,
    required this.dataInicio,
    required this.dataFim,
    required this.itens,
    required this.status,
  });

  factory AluguelModel.fromMap(String id, Map<String, dynamic> map) {
    return AluguelModel(
      id: id,
      clienteId: map['clienteId'],
      clienteNome: map['clienteNome'],
      kitId: map['kitId'],
      kitNome: map['kitNome'],
      valor: (map['valor'] ?? 0).toDouble(),
      dataInicio: DateTime.parse(map['dataInicio']),
      dataFim: DateTime.parse(map['dataFim']),
      status: map['status'] == 'finalizado'
          ? StatusAluguel.finalizado
          : StatusAluguel.ativo,
      itens: (map['itens'] as List)
          .map((e) => KitItemModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      'kitId': kitId,
      'kitNome': kitNome,
      'valor': valor,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'status': status.name,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }

  AluguelModel copyWith({
    StatusAluguel? status,
  }) {
    return AluguelModel(
      id: id,
      clienteId: clienteId,
      clienteNome: clienteNome,
      kitId: kitId,
      kitNome: kitNome,
      valor: valor,
      dataInicio: dataInicio,
      dataFim: dataFim,
      itens: itens,
      status: status ?? this.status,
    );
  }
}
