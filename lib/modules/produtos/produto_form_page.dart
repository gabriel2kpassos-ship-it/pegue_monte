import 'package:flutter/material.dart';
import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutoFormPage extends StatefulWidget {
  const ProdutoFormPage({super.key});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final _service = ProdutoService();

  ProdutoModel? _produto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is ProdutoModel) {
      _produto = args;
      _nomeController.text = _produto!.nome;
      _quantidadeController.text = _produto!.quantidade.toString();
    }
  }

  Future<void> _salvar() async {
    if (_nomeController.text.isEmpty ||
        _quantidadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final quantidade = int.tryParse(_quantidadeController.text) ?? 0;

    final produto = ProdutoModel(
      id: _produto?.id ?? '',
      nome: _nomeController.text,
      quantidade: quantidade,
    );

    if (_produto == null) {
      await _service.criar(produto);
    } else {
      await _service.atualizar(produto);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = _produto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration:
                  const InputDecoration(labelText: 'Nome do produto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade em quantidade',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
