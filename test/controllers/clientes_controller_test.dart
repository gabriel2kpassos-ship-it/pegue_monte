import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pegue_e_monte/core/services/cliente_service.dart';
import 'package:pegue_e_monte/modules/clientes/clientes_controller.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ClienteService service;
  late ClientesController controller;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    service = ClienteService(firestore);
    controller = ClientesController(service);
  });

  test('inicia com lista vazia', () async {
    await Future.delayed(const Duration(milliseconds: 10));
    expect(controller.clientes.isEmpty, true);
  });

  test('adiciona cliente', () async {
    await controller.adicionar('Ana', '11888888888');
    await Future.delayed(const Duration(milliseconds: 10));

    expect(controller.clientes.length, 1);
    expect(controller.clientes.first.nome, 'Ana');
  });
}
