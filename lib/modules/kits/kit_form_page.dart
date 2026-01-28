import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/cloudinary_service.dart';
import '../../core/services/image_service.dart';
import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';
import '../../models/kit_item_model.dart';
import '../../models/kit_model.dart';
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
  final _imageService = ImageService();
  final _cloudinary = const CloudinaryService();

  late TextEditingController _nomeController;
  late TextEditingController _precoController;

  XFile? _imageFile;
  Uint8List? _imageBytes;

  List<ProdutoModel> _produtos = [];
  List<KitItemModel> _itens = [];

  bool _salvando = false;
  bool get _editando => widget.kit != null;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.kit?.nome ?? '');
    _precoController = TextEditingController(
      text: widget.kit != null
          ? widget.kit!.preco.toStringAsFixed(2).replaceAll('.', ',')
          : '',
    );

    _itens = List.from(widget.kit?.itens ?? []);
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final lista = await _produtoService.listarProdutos().first;
    if (!mounted) return;
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

  double _converterPreco() {
    final texto =
        _precoController.text.replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(texto) ?? 0.0;
  }

  void _showImageSourceSelection() {
    _imageService.showImagePickerModal(
      context,
      onImagePicked: (file) async {
        if (file == null) return;
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        setState(() {
          _imageFile = file;
          _imageBytes = bytes;
        });
      },
    );
  }

  ImageProvider<Object>? _buildAvatarImage() {
    if (_imageBytes != null) {
      return MemoryImage(_imageBytes!);
    }
    final url = widget.kit?.fotoUrl;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
    return null;
  }

  Future<CloudinaryUploadResult?> _uploadToCloudinaryIfNeeded() async {
    if (_imageBytes == null) return null;

    final filename = (_imageFile?.name.trim().isNotEmpty ?? false)
        ? _imageFile!.name
        : 'kit_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return _cloudinary.uploadImageBytes(
      bytes: _imageBytes!,
      filename: filename,
      folder: 'pegue_e_monte/kits',
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_itens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos 1 produto ao kit')),
      );
      return;
    }

    setState(() => _salvando = true);

    final oldPublicId = widget.kit?.fotoPublicId;

    try {
      final upload = await _uploadToCloudinaryIfNeeded();

      final kit = KitModel(
        id: widget.kit?.id ?? '',
        nome: _nomeController.text.trim(),
        preco: _converterPreco(),
        itens: _itens,
        fotoUrl: upload?.url ?? widget.kit?.fotoUrl,
        fotoPublicId: upload?.publicId ?? widget.kit?.fotoPublicId,
      );

      if (_editando) {
        await _kitService.atualizarKit(kit);
      } else {
        await _kitService.criarKit(kit);
      }

      // ✅ se trocou a imagem, apaga a antiga (best effort)
      if (upload != null &&
          oldPublicId != null &&
          oldPublicId.isNotEmpty &&
          oldPublicId != upload.publicId) {
        try {
          await _cloudinary.deleteImage(oldPublicId);
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar kit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = _buildAvatarImage();

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Kit' : 'Novo Kit'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceSelection,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nomeController,
                        decoration:
                            const InputDecoration(labelText: 'Nome do kit'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o nome' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _precoController,
                        decoration: const InputDecoration(
                            labelText: 'Preço (ex: 50,85)'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9,\.]')),
                        ],
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o preço' : null,
                      ),
                      const SizedBox(height: 12),
                      ..._itens.map(
                        (item) => ListTile(
                          title: Text(item.produtoNome),
                          subtitle: Text('Quantidade: ${item.quantidade}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerItem(item),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar Kit'),
                ),
              ),
            ),
          ],
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
  State<_AdicionarProdutoModal> createState() => _AdicionarProdutoModalState();
}

class _AdicionarProdutoModalState extends State<_AdicionarProdutoModal> {
  final _pesquisaController = TextEditingController();
  late Map<String, int> _quantidades;

  @override
  void initState() {
    super.initState();
    _quantidades = {for (var p in widget.produtos) p.id: 0};
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;
    final availableHeight = mediaQuery.size.height - bottomPadding;
    final height = math.min(mediaQuery.size.height * 0.7, availableHeight);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: height,
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
      ),
    );
  }
}
