import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../core/services/kit_service.dart';
import '../../models/kit_item_model.dart';
import '../../models/kit_model.dart';

class KitFormPage extends StatefulWidget {
  const KitFormPage({super.key});

  @override
  State<KitFormPage> createState() => _KitFormPageState();
}

class _KitFormPageState extends State<KitFormPage> {
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _service = KitService();

  final List<KitItemModel> _itens = [];
  KitModel? _kit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is KitModel) {
      _kit = args;
      _nomeController.text = _kit!.nome;
      _precoController.text =
          _kit!.preco.toStringAsFixed(2).replaceAll('.', ',');
      _itens
        ..clear()
        ..addAll(_kit!.itens);
    }
  }

  double _parsePreco(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  int _quantidadeAtual(String produtoId) {
    final index = _itens.indexWhere((e) => e.produtoId == produtoId);
    return index == -1 ? 0 : _itens[index].quantidade;
  }

  void _alterarQuantidade({
    required String produtoId,
    required String nome,
    required int novaQuantidade,
    required int quantidade,
  }) {
    if (novaQuantidade < 0 || novaQuantidade > quantidade) return;

    final index = _itens.indexWhere((e) => e.produtoId == produtoId);

    setState(() {
      if (novaQuantidade == 0) {
        if (index != -1) _itens.removeAt(index);
      } else {
        if (index == -1) {
          _itens.add(
            KitItemModel(
              produtoId: produtoId,
              nome: nome,
              quantidade: novaQuantidade,
            ),
          );
        } else {
          _itens[index] = KitItemModel(
            produtoId: produtoId,
            nome: nome,
            quantidade: novaQuantidade,
          );
        }
      }
    });
  }

  Future<void> _salvar() async {
    final nome = _nomeController.text.trim();
    final preco = _parsePreco(_precoController.text);

    if (nome.isEmpty || preco <= 0 || _itens.isEmpty) return;

    if (_kit == null) {
      await _service.criar(
        KitModel(id: '', nome: nome, preco: preco, itens: _itens),
      );
    } else {
      await _service.atualizar(
        KitModel(
          id: _kit!.id,
          nome: nome,
          preco: preco,
          itens: _itens,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _abrirSelecaoProdutos() {
    final pesquisaController = TextEditingController();
    bool somenteComquantidade = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    const Text(
                      'Adicionar Produtos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    /// PESQUISA
                    TextField(
                      controller: pesquisaController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Pesquisar produto',
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),

                    /// FILTRO
                    SwitchListTile(
                      title: const Text('Somente com quantidade'),
                      value: somenteComquantidade,
                      onChanged: (v) =>
                          setModalState(() => somenteComquantidade = v),
                    ),

                    /// LISTA DE PRODUTOS
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('produtos')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final filtro =
                              pesquisaController.text.toLowerCase();

                          final produtos = snapshot.data!.docs.where((doc) {
                            final nome =
                                doc['nome'].toString().toLowerCase();
                            final quantidade =
                                doc['quantidade'] as int;

                            final matchTexto =
                                nome.contains(filtro);
                            final matchquantidade =
                                !somenteComquantidade || quantidade > 0;

                            return matchTexto && matchquantidade;
                          }).toList();

                          return ListView.builder(
                            itemCount: produtos.length,
                            itemBuilder: (context, index) {
                              final doc = produtos[index];
                              final produtoId = doc.id;
                              final nome = doc['nome'];
                              final quantidade =
                                  doc['quantidade'] as int;

                              final quantidadeAtual =
                                  _quantidadeAtual(produtoId);

                              return ListTile(
                                title: Text(nome),
                                subtitle:
                                    Text('quantidade: $quantidade'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          const Icon(Icons.remove),
                                      onPressed: quantidadeAtual > 0
                                          ? () {
                                              _alterarQuantidade(
                                                produtoId:
                                                    produtoId,
                                                nome: nome,
                                                novaQuantidade:
                                                    quantidadeAtual -
                                                        1,
                                                quantidade: quantidade,
                                              );
                                              setModalState(() {});
                                            }
                                          : null,
                                    ),
                                    Text('$quantidadeAtual'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed:
                                          quantidadeAtual < quantidade
                                              ? () {
                                                  _alterarQuantidade(
                                                    produtoId:
                                                        produtoId,
                                                    nome: nome,
                                                    novaQuantidade:
                                                        quantidadeAtual +
                                                            1,
                                                    quantidade: quantidade,
                                                  );
                                                  setModalState(() {});
                                                }
                                              : null,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    /// RESUMO
                    if (_itens.isNotEmpty) ...[
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Itens adicionados',
                          style:
                              TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._itens.map(
                        (item) => Text(
                          '• ${item.nome} (${item.quantidade})',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    /// CONCLUIR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Concluir seleção'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Montar Kit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DADOS DO KIT
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration:
                          const InputDecoration(labelText: 'Nome do Kit'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _precoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d,\.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Preço do Kit (R\$)',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ITENS DO KIT
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Itens do Kit',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _itens.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhum produto adicionado',
                                ),
                              )
                            : ListView.builder(
                                itemCount: _itens.length,
                                itemBuilder: (context, index) {
                                  final item = _itens[index];
                                  return ListTile(
                                    title: Text(item.nome),
                                    subtitle: Text(
                                        'Quantidade: ${item.quantidade}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _itens.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Produtos'),
                onPressed: _abrirSelecaoProdutos,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar Kit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
