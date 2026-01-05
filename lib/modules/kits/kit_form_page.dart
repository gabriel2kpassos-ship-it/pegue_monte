import 'package:flutter/material.dart';

import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';
import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';
import '../../models/produto_model.dart';

class KitFormPage extends StatefulWidget {
  final KitModel? kit;

  const KitFormPage({super.key, this.kit});

  @override
  State<KitFormPage> createState() => _KitFormPageState();
}

class _KitFormPageState extends State<KitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _kitService = KitService();
  final _produtoService = ProdutoService();

  late TextEditingController _nomeController;
  late TextEditingController _precoController;

  List<ProdutoModel> _produtos = [];
  List<KitItemModel> _itens = [];

  bool _salvando = false;
  bool get _editando => widget.kit != null;

  @override
  void initState() {
    super.initState();
    _nomeController =
        TextEditingController(text: widget.kit?.nome ?? '');
    _precoController =
        TextEditingController(text: widget.kit?.preco.toString() ?? '');
    _itens = List.from(widget.kit?.itens ?? []);
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final lista = await _produtoService.listarProdutos().first;
    setState(() => _produtos = lista);
  }

  void _abrirAdicionarProduto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AdicionarProdutoModal(
        produtos: _produtos,
        onConfirmar: (novosItens) {
          setState(() => _itens.addAll(novosItens));
        },
      ),
    );
  }

  void _removerItem(KitItemModel item) {
    setState(() => _itens.remove(item));
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_itens.isEmpty) return;

    setState(() => _salvando = true);

    final kit = KitModel(
      id: widget.kit?.id ?? '',
      nome: _nomeController.text.trim(),
      preco: double.parse(_precoController.text),
      itens: _itens,
    );

    if (_editando) {
      await _kitService.atualizarKit(kit);
    } else {
      await _kitService.criarKit(kit);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Kit' : 'Novo Kit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do kit'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o preço' : null,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: _itens
                      .map(
                        (item) => ListTile(
                          title: Text(item.produtoNome),
                          subtitle:
                              Text('Quantidade: ${item.quantidade}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerItem(item),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              GestureDetector(
                onTap: _abrirAdicionarProduto,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '+ Adicionar Produto',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: const Text('Salvar Kit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= MODAL =================

class _AdicionarProdutoModal extends StatefulWidget {
  final List<ProdutoModel> produtos;
  final void Function(List<KitItemModel>) onConfirmar;

  const _AdicionarProdutoModal({
    required this.produtos,
    required this.onConfirmar,
  });

  @override
  State<_AdicionarProdutoModal> createState() =>
      _AdicionarProdutoModalState();
}

class _AdicionarProdutoModalState extends State<_AdicionarProdutoModal> {
  final _pesquisaController = TextEditingController();
  late Map<String, int> _quantidades;

  @override
  void initState() {
    super.initState();
    _quantidades = {
      for (var p in widget.produtos) p.id: 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pesquisaController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar produto',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            Expanded(
              child: ListView(
                children: widget.produtos
                    .where(
                      (p) => p.nome
                          .toLowerCase()
                          .contains(_pesquisaController.text.toLowerCase()),
                    )
                    .map(
                      (p) => ListTile(
                        title: Text(p.nome),
                        subtitle: Text('Estoque: ${p.quantidade}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantidades[p.id]! > 0
                                  ? () => setState(() {
                                        _quantidades[p.id] =
                                            _quantidades[p.id]! - 1;
                                      })
                                  : null,
                            ),
                            Text('${_quantidades[p.id]}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _quantidades[p.id]! < p.quantidade
                                  ? () => setState(() {
                                        _quantidades[p.id] =
                                            _quantidades[p.id]! + 1;
                                      })
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Adicionar Produtos'),
                onPressed: () {
                  final itens = widget.produtos
                      .where((p) => _quantidades[p.id]! > 0)
                      .map(
                        (p) => KitItemModel(
                          produtoId: p.id,
                          produtoNome: p.nome,
                          quantidade: _quantidades[p.id]!,
                        ),
                      )
                      .toList();

                  widget.onConfirmar(itens);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
