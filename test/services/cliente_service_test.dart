import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pegue_e_monte/core/services/cliente_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ClienteService service;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    service = ClienteService(firestore);
  });

  test('adiciona cliente corretamente', () async {
    await service.adicionar('Carlos', '11999999999');

    final snapshot =
        await firestore.collection('clientes').get();

    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first['nome'], 'Carlos');
    expect(snapshot.docs.first['telefone'], '11999999999');
  });
}
