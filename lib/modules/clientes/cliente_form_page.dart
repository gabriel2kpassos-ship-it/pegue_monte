import 'package:flutter/material.dart';

import '../../core/services/cliente_service.dart';
import '../../models/cliente_model.dart';
import '../../core/utils/phone_input_formatter.dart';

class ClienteFormPage extends StatefulWidget {
  final ClienteModel? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ClienteService();

  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;

  bool _salvando = false;

  bool get _editando => widget.cliente != null;

  @override
  void initState() {
    super.initState();

    _nomeController =
        TextEditingController(text: widget.cliente?.nome ?? '');
    _telefoneController =
        TextEditingController(text: widget.cliente?.telefone ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final cliente = ClienteModel(
        id: widget.cliente?.id ?? '',
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
      );

      if (_editando) {
        await _service.atualizarCliente(cliente);
      } else {
        await _service.criarCliente(cliente);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
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
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const CircularProgressIndicator()
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
