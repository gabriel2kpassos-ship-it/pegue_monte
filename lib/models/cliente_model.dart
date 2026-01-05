import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  final String id;
  final String nome;
  final String telefone;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  /// Converte Firestore → Dart
  factory ClienteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return ClienteModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      telefone: data['telefone'] ?? '',
    );
  }

  /// Converte Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
    };
  }
}
