import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

/// Resultado padrão do upload (url + publicId) retornado pelo seu Worker.
@immutable
class CloudinaryUploadResult {
  final String url;
  final String publicId;

  const CloudinaryUploadResult({
    required this.url,
    required this.publicId,
  });

  factory CloudinaryUploadResult.fromJson(Map<String, dynamic> json) {
    final url = (json['url'] ?? '').toString();
    final publicId = (json['publicId'] ?? '').toString();

    if (url.isEmpty || publicId.isEmpty) {
      throw Exception('Resposta inválida do upload: url/publicId ausentes.');
    }

    return CloudinaryUploadResult(url: url, publicId: publicId);
  }
}

/// Serviço que conversa com o seu Cloudflare Worker:
/// - POST {baseUrl}/upload  (multipart/form-data)
/// - POST {baseUrl}/delete  (application/json { publicId })
class CloudinaryService {
  /// Seu Worker (você já testou com curl e está OK)
  static const String _defaultBaseUrl =
      'https://pegue-e-monte-worker.gabriel2k-passos.workers.dev';

  final String baseUrl;

  const CloudinaryService({
    this.baseUrl = _defaultBaseUrl,
  });

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  /// Upload por BYTES (funciona no Web e no Mobile).
  Future<CloudinaryUploadResult> uploadImageBytes({
    required Uint8List bytes,
    required String filename,
    String folder = 'pegue_e_monte',
    Duration timeout = const Duration(seconds: 40),
  }) async {
    if (bytes.isEmpty) {
      throw Exception('Arquivo de imagem vazio (0 bytes).');
    }

    final req = http.MultipartRequest('POST', _u('/upload'));
    req.fields['folder'] = folder;

    final mediaType = _guessMediaType(filename);

    req.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: mediaType,
      ),
    );

    http.StreamedResponse streamed;
    try {
      streamed = await req.send().timeout(timeout);
    } on TimeoutException {
      throw Exception(
        'Timeout no upload (Worker/Cloudinary demorou demais). Tente novamente.',
      );
    } catch (e) {
      throw Exception('Falha ao enviar upload para o Worker: $e');
    }

    final body = await streamed.stream.bytesToString();

    Map<String, dynamic>? jsonBody;
    try {
      jsonBody = json.decode(body) as Map<String, dynamic>;
    } catch (_) {
      jsonBody = null;
    }

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      final details = jsonBody != null ? jsonEncode(jsonBody) : body;
      throw Exception(
        'Upload falhou (HTTP ${streamed.statusCode}). Resposta: $details',
      );
    }

    if (jsonBody == null) {
      throw Exception('Upload OK, mas resposta não é JSON: $body');
    }

    final ok = jsonBody['ok'] == true;
    if (!ok) {
      throw Exception('Upload falhou: ${jsonEncode(jsonBody)}');
    }

    return CloudinaryUploadResult.fromJson(jsonBody);
  }

  /// Delete pelo publicId do Cloudinary (via Worker).
  Future<void> deleteImage(
    String publicId, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final id = publicId.trim();
    if (id.isEmpty) return;

    http.Response res;
    try {
      res = await http
          .post(
            _u('/delete'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'publicId': id}),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw Exception('Timeout ao deletar imagem (Worker/Cloudinary).');
    } catch (e) {
      throw Exception('Falha ao chamar delete no Worker: $e');
    }

    Map<String, dynamic>? jsonBody;
    try {
      jsonBody = json.decode(res.body) as Map<String, dynamic>;
    } catch (_) {
      jsonBody = null;
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final details = jsonBody != null ? jsonEncode(jsonBody) : res.body;
      throw Exception(
        'Delete falhou (HTTP ${res.statusCode}). Resposta: $details',
      );
    }

    if (jsonBody == null) {
      throw Exception('Delete OK, mas resposta não é JSON: ${res.body}');
    }

    final ok = jsonBody['ok'] == true;
    if (!ok) {
      throw Exception('Delete falhou: ${jsonEncode(jsonBody)}');
    }
  }

  http_parser.MediaType _guessMediaType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return http_parser.MediaType('image', 'png');
    if (lower.endsWith('.webp')) return http_parser.MediaType('image', 'webp');
    if (lower.endsWith('.gif')) return http_parser.MediaType('image', 'gif');
    return http_parser.MediaType('image', 'jpeg');
  }
}
