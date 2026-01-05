import 'package:flutter_test/flutter_test.dart';
import 'package:gestao_kits/core/services/aluguel_service.dart';
import 'package:gestao_kits/core/services/produto_service.dart';
import 'package:gestao_kits/models/aluguel_model.dart';
import 'package:gestao_kits/models/kit_item_model.dart';
import 'package:gestao_kits/models/produto_model.dart';

void main() {
  group('AluguelService', () {
    late ProdutoService produtoService;
    late AluguelService aluguelService;

    setUp(() {
      produtoService = ProdutoService();
      aluguelService = AluguelService(produtoService);

      produtoService.adicionar(
        ProdutoModel(
          id: 'p1',
          nome: 'Produto Teste',
          estoque: 10,
        ),
      );
    });

    test('deve baixar quantidadeao adicionar aluguel', () {
      final aluguel = AluguelModel(
        id: 'a1',
        clienteId: 'c1',
        clienteNome: 'Cliente',
        kitId: 'k1',
        kitNome: 'Kit',
        itens: const [
          KitItemModel(
            produtoId: 'p1',
            produtoNome: 'Produto Teste',
            quantidade: 3,
          ),
        ],
        dataInicio: DateTime.now(),
        dataDevolucao: DateTime.now().add(const Duration(days: 1)),
        status: AluguelStatus.ativo,
      );

      aluguelService.adicionar(aluguel);

      final produto = produtoService.obterPorId('p1')!;
      expect(produto.estoque, 7);
    });

    test('deve devolver quantidadeao finalizar aluguel', () {
      final aluguel = AluguelModel(
        id: 'a1',
        clienteId: 'c1',
        clienteNome: 'Cliente',
        kitId: 'k1',
        kitNome: 'Kit',
        itens: const [
          KitItemModel(
            produtoId: 'p1',
            produtoNome: 'Produto Teste',
            quantidade: 4,
          ),
        ],
        dataInicio: DateTime.now(),
        dataDevolucao: DateTime.now().add(const Duration(days: 1)),
        status: AluguelStatus.ativo,
      );

      aluguelService.adicionar(aluguel);
      aluguelService.finalizarAluguel('a1');

      final produto = produtoService.obterPorId('p1')!;
      expect(produto.estoque, 10);
    });

    test('não deve finalizar aluguel já finalizado', () {
      final aluguel = AluguelModel(
        id: 'a1',
        clienteId: 'c1',
        clienteNome: 'Cliente',
        kitId: 'k1',
        kitNome: 'Kit',
        itens: const [
          KitItemModel(
            produtoId: 'p1',
            produtoNome: 'Produto Teste',
            quantidade: 2,
          ),
        ],
        dataInicio: DateTime.now(),
        dataDevolucao: DateTime.now().add(const Duration(days: 1)),
        status: AluguelStatus.finalizado,
      );

      aluguelService.adicionar(aluguel);
      aluguelService.finalizarAluguel('a1');

      final produto = produtoService.obterPorId('p1')!;
      expect(produto.estoque, 8);
    });
  });
}
