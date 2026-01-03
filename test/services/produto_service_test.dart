import 'package:flutter_test/flutter_test.dart';
import 'package:gestao_kits/core/services/produto_service.dart';
import 'package:gestao_kits/models/produto_model.dart';

void main() {
  group('ProdutoService', () {
    late ProdutoService service;

    setUp(() {
      service = ProdutoService();
    });

    test('deve adicionar e listar produtos', () {
      final produto = ProdutoModel(
        id: '1',
        nome: 'Produto A',
        estoque: 10,
      );

      service.adicionar(produto);

      final lista = service.listar();
      expect(lista.length, 1);
      expect(lista.first.nome, 'Produto A');
    });

    test('deve baixar estoque corretamente', () {
      final produto = ProdutoModel(
        id: '1',
        nome: 'Produto A',
        estoque: 10,
      );

      service.adicionar(produto);
      service.baixarEstoque('1', 3);

      final atualizado = service.obterPorId('1')!;
      expect(atualizado.estoque, 7);
    });

    test('deve devolver estoque corretamente', () {
      final produto = ProdutoModel(
        id: '1',
        nome: 'Produto A',
        estoque: 5,
      );

      service.adicionar(produto);
      service.devolverEstoque('1', 4);

      final atualizado = service.obterPorId('1')!;
      expect(atualizado.estoque, 9);
    });

    test('temEstoque deve validar corretamente', () {
      final produto = ProdutoModel(
        id: '1',
        nome: 'Produto A',
        estoque: 2,
      );

      service.adicionar(produto);

      expect(service.temEstoque('1', 1), true);
      expect(service.temEstoque('1', 2), true);
      expect(service.temEstoque('1', 3), false);
    });
  });
}
