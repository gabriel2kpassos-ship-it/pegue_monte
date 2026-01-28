import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image/image.dart' as img;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pega a imagem já com limite de tamanho (isso reduz lag e evita uploads gigantes)
  Future<XFile?> pickImage(ImageSource source) async {
    return _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
  }

  /// Crop + compressão final (JPEG) para garantir upload rápido no Web e no mobile
  Future<XFile?> cropImage(BuildContext context, XFile file) async {
    final controller = CropController();
    final Uint8List bytes = await file.readAsBytes();

    // ✅ Impede uso de BuildContext inválido após await
    if (!context.mounted) return null;

    bool cropping = false;

    return showDialog<XFile?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Crop(
                        controller: controller,
                        image: bytes,
                        onCropped: (croppedBytes) async {
                          final compressed = _compressToJpeg(
                            croppedBytes,
                            maxSide: 1280,
                            quality: 82,
                          );

                          Navigator.pop(
                            ctx,
                            XFile.fromData(
                              compressed,
                              mimeType: 'image/jpeg',
                              name:
                                  'cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed:
                                cropping ? null : () => Navigator.pop(ctx),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: cropping
                                ? null
                                : () {
                                    setState(() => cropping = true);
                                    controller.crop();
                                  },
                            child: const Text('Recortar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (cropping)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Modal de seleção
  void showImagePickerModal(
    BuildContext context, {
    required Function(XFile?) onImagePicked,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tirar Foto'),
              onTap: () async {
                Navigator.pop(ctx);

                final picked = await pickImage(ImageSource.camera);
                if (picked == null) return;

                if (!ctx.mounted) return;

                final cropped = await cropImage(ctx, picked);
                onImagePicked(cropped);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da Galeria'),
              onTap: () async {
                Navigator.pop(ctx);

                final picked = await pickImage(ImageSource.gallery);
                if (picked == null) return;

                if (!ctx.mounted) return;

                final cropped = await cropImage(ctx, picked);
                onImagePicked(cropped);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// 🔥 O que resolve o seu timeout no Web:
  /// - transforma qualquer coisa (png/jpg) em JPEG
  /// - reduz para no máx. maxSide
  /// - compressão com qualidade
  Uint8List _compressToJpeg(
    Uint8List inputBytes, {
    required int maxSide,
    required int quality,
  }) {
    try {
      final decoded = img.decodeImage(inputBytes);
      if (decoded == null) return inputBytes;

      final resized = img.copyResize(
        decoded,
        width: decoded.width >= decoded.height ? maxSide : null,
        height: decoded.height > decoded.width ? maxSide : null,
        interpolation: img.Interpolation.average,
      );

      return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
    } catch (_) {
      return inputBytes;
    }
  }
}
