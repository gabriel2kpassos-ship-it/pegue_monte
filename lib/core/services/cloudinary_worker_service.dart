import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryWorkerService {
  // ✅ TROQUE para o seu Worker:
  static const String _baseUrl =
      'https://pegue-e-monte-worker.gabriel2k-passos.workers.dev';

  Future<void> deleteByPublicId(String publicId) async {
    final uri = Uri.parse('$_baseUrl/delete');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'publicId': publicId}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
          'Falha ao deletar no Worker: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);
    if (data is! Map || data['ok'] != true) {
      throw Exception('Worker respondeu erro: ${res.body}');
    }
  }
}
