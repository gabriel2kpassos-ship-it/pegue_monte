import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/cloudinary_service.dart';
import '../../core/services/image_service.dart';
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
  final _imageService = ImageService();
  final _cloudinary = const CloudinaryService();

  late final TextEditingController _nomeController;
  late final TextEditingController _quantidadeController;

  XFile? _imageFile;
  Uint8List? _imageBytes;

  bool _salvando = false;
  bool get _editando => widget.produto != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
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
    final url = widget.produto?.fotoUrl;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
    return null;
  }

  Future<CloudinaryUploadResult?> _uploadToCloudinaryIfNeeded() async {
    if (_imageBytes == null) return null;

    final filename = (_imageFile?.name.trim().isNotEmpty ?? false)
        ? _imageFile!.name
        : 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return _cloudinary.uploadImageBytes(
      bytes: _imageBytes!,
      filename: filename,
      folder: 'pegue_e_monte/produtos',
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final oldPublicId = widget.produto?.fotoPublicId;

    try {
      final upload = await _uploadToCloudinaryIfNeeded();

      final produto = ProdutoModel(
        id: widget.produto?.id ?? '',
        nome: _nomeController.text.trim(),
        quantidade: int.parse(_quantidadeController.text),
        fotoUrl: upload?.url ?? widget.produto?.fotoUrl,
        fotoPublicId: upload?.publicId ?? widget.produto?.fotoPublicId,
      );

      if (_editando) {
        await _service.atualizarProduto(produto);
      } else {
        await _service.criarProduto(produto);
      }

      // ✅ se trocou a imagem, apaga a antiga (best effort)
      if (upload != null &&
          oldPublicId != null &&
          oldPublicId.isNotEmpty &&
          oldPublicId != upload.publicId) {
        try {
          await _cloudinary.deleteImage(oldPublicId);
        } catch (_) {
          // não trava o save por causa disso
        }
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
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
        title: Text(_editando ? 'Editar Produto' : 'Novo Produto'),
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
                      const SizedBox(height: 16),
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
                      : const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
