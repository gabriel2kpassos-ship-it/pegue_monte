import 'package:flutter/material.dart';

import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';
import '../../models/produto_model.dart';
import 'kits_controller.dart';

class KitFormPage extends StatefulWidget {
  final KitModel? kit;

  const KitFormPage({super.key, this.kit});

  @override
  State<KitFormPage> createState() => _KitFormPageState();
}

class _KitFormPageState extends State<KitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = KitsController();

  late final TextEditingController _nomeController;
  late final TextEditingController _precoController;

  final List<KitItemModel> _itens = [];

  ProdutoModel? _produtoSelecionado;
  final TextEditingController _quantidadeController =
      TextEditingController();

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.kit?.nome ?? '');
    _precoController = TextEditingController(
      text: widget.kit?.preco.toString() ?? '',
    );
    if (widget.kit != null) {
      _itens.addAll(widget.kit!.itens);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _adicionarItem() {
    if (_produtoSelecionado == null) return;

    final quantidade = int.tryParse(_quantidadeController.text) ?? 0;
    if (quantidade <= 0) return;

    if (!_controller.podeAdicionarItem(
      _produtoSelecionado!.id,
      quantidade,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estoque insuficiente')),
      );
      return;
    }

    setState(() {
      _itens.add(
        KitItemModel(
          produtoId: _produtoSelecionado!.id,
          produtoNome: _produtoSelecionado!.nome,
          quantidade: quantidade,
        ),
      );
      _produtoSelecionado = null;
      _quantidadeController.clear();
    });
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate() || _itens.isEmpty) return;

    setState(() => _salvando = true);

    final kit = KitModel(
      id: widget.kit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      preco: double.parse(_precoController.text),
      itens: List.from(_itens),
    );

    _controller.salvar(kit);

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kit salvo com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = _controller.produtoService.listar();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kit == null ? 'Novo Kit' : 'Editar Kit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Kit'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || double.tryParse(v) == null
                        ? 'Preço inválido'
                        : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Itens do Kit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<ProdutoModel>(
                      initialValue: _produtoSelecionado,
                      items: produtos
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text('${p.nome} (Estoque: ${p.estoque})'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _produtoSelecionado = value);
                      },
                      decoration:
                          const InputDecoration(labelText: 'Produto'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Qtd'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _adicionarItem,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._itens.map(
                (item) => ListTile(
                  title: Text(item.produtoNome),
                  trailing: Text('Qtd: ${item.quantidade}'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvando ? null : _salvar,
                child: _salvando
                    ? const CircularProgressIndicator()
                    : const Text('Salvar Kit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
