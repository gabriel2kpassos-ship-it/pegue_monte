import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/cliente_model.dart';
import 'clientes_controller.dart';
import '../../core/utils/phone_input_formatter.dart';

class ClienteFormPage extends StatefulWidget {
  final ClienteModel? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController telefoneController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: widget.cliente?.nome);

    // Se estiver editando, o telefone vem SEM formatação (só números)
    // A máscara aplica a formatação automaticamente
    telefoneController = TextEditingController(
      text: widget.cliente?.telefone,
    );
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;

    final telefoneNumerico =
        telefoneController.text.replaceAll(RegExp(r'\D'), '');

    if (widget.cliente == null) {
      ClientesController.adicionar(
        ClienteModel(
          id: ClientesController.gerarId(),
          nome: nomeController.text.trim(),
          telefone: telefoneNumerico,
        ),
      );
    } else {
      ClientesController.atualizar(
        widget.cliente!.copyWith(
          nome: nomeController.text.trim(),
          telefone: telefoneNumerico,
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneInputFormatter],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '(11) 91234-5678',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Informe o telefone';
                  }

                  final numeric = v.replaceAll(RegExp(r'\D'), '');
                  if (numeric.length != 11) {
                    return 'Telefone inválido';
                  }

                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvar,
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
