import 'package:flutter/material.dart';
import '../../models/produto_model.dart';
import 'produtos_controller.dart';

class ProdutoFormPage extends StatefulWidget {
  final ProdutoModel? produto;

  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController quantidadeController;

  @override
  void initState() {
    nomeController = TextEditingController(text: widget.produto?.nome);
    quantidadeController =
        TextEditingController(text: widget.produto?.quantidade.toString());
    super.initState();
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;

    final quantidade = int.parse(quantidadeController.text);

    if (widget.produto == null) {
      ProdutosController.adicionar(
        ProdutoModel(
          id: ProdutosController.gerarId(),
          nome: nomeController.text,
          quantidade: quantidade,
        ),
      );
    } else {
      ProdutosController.atualizar(
        widget.produto!.copyWith(
          nome: nomeController.text,
          quantidade: quantidade,
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome do produto'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantidadeController,
                decoration:
                    const InputDecoration(labelText: 'Quantidade em estoque'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null
                        ? 'Quantidade inválida'
                        : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvar,
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
