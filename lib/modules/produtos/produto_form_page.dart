import 'package:flutter/material.dart';

import '../../core/services/produto_service.dart';
import '../../models/produto_model.dart';

class ProdutoFormPage extends StatefulWidget {
  final ProdutoModel? produto;

  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProdutoService();

  late final TextEditingController _nomeController;
  late final TextEditingController _quantidadeController;

  bool _salvando = false;

  bool get _editando => widget.produto != null;

  @override
  void initState() {
    super.initState();

    _nomeController =
        TextEditingController(text: widget.produto?.nome ?? '');
    _quantidadeController = TextEditingController(
      text: widget.produto?.quantidade.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final produto = ProdutoModel(
        id: widget.produto?.id ?? '',
        nome: _nomeController.text.trim(),
        quantidade: int.parse(_quantidadeController.text),
      );

      if (_editando) {
        await _service.atualizarProduto(produto);
      } else {
        await _service.criarProduto(produto);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em estoque',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  final qtd = int.tryParse(value);
                  if (qtd == null || qtd < 0) {
                    return 'Quantidade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const CircularProgressIndicator()
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
