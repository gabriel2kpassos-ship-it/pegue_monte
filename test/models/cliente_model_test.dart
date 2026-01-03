import 'package:flutter_test/flutter_test.dart';
import 'package:gestao_kits/models/cliente_model.dart';

void main() {
  group('ClienteModel', () {
    test('toMap e fromMap devem funcionar corretamente', () {
      final cliente = ClienteModel(
        id: '1',
        nome: 'João',
        telefone: '11999999999',
      );

      final map = cliente.toMap();
      final fromMap = ClienteModel.fromMap(map);

      expect(fromMap.id, cliente.id);
      expect(fromMap.nome, cliente.nome);
      expect(fromMap.telefone, cliente.telefone);
    });

    test('copyWith deve alterar apenas os campos informados', () {
      final cliente = ClienteModel(
        id: '1',
        nome: 'João',
        telefone: '111',
      );

      final novo = cliente.copyWith(nome: 'Maria');

      expect(novo.id, '1');
      expect(novo.nome, 'Maria');
      expect(novo.telefone, '111');
    });
  });
}
