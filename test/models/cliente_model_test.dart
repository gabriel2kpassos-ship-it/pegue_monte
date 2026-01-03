import 'package:flutter_test/flutter_test.dart';
import 'package:pegue_e_monte/models/cliente_model.dart';

void main() {
  test('deve criar um ClienteModel válido', () {
    final cliente = ClienteModel(
      id: '1',
      nome: 'Maria',
      telefone: '11988887777',
    );

    expect(cliente.id, '1');
    expect(cliente.nome, 'Maria');
    expect(cliente.telefone, '11988887777');
  });
}
