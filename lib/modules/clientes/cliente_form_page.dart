import 'package:flutter/material.dart';

import '../../core/services/cliente_service.dart';
import '../../core/utils/phone_input_formatter.dart';
import '../../core/utils/phone_display_formatter.dart';
import '../../models/cliente_model.dart';

class ClienteFormPage extends StatefulWidget {
  const ClienteFormPage({super.key});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _service = ClienteService();

  ClienteModel? _cliente;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is ClienteModel) {
      _cliente = args;
      _nomeController.text = _cliente!.nome;
      _telefoneController.text =
          PhoneDisplayFormatter.format(_cliente!.telefone);
    }
  }

  String _somenteNumeros(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> _salvar() async {
    final nome = _nomeController.text.trim();
    final telefone = _somenteNumeros(_telefoneController.text);

    if (nome.isEmpty || telefone.isEmpty) return;

    if (_cliente == null) {
      await _service.criar(
        ClienteModel(
          id: '',
          nome: nome,
          telefone: telefone,
        ),
      );
    } else {
      await _service.atualizar(
        ClienteModel(
          id: _cliente!.id,
          nome: nome,
          telefone: telefone,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = _cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneInputFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Telefone',
                hintText: '(11) 91234-5678',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
