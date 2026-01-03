import 'package:flutter/material.dart';
import '../../models/cliente_model.dart';
import 'clientes_controller.dart';

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
    nomeController = TextEditingController(text: widget.cliente?.nome);
    telefoneController =
        TextEditingController(text: widget.cliente?.telefone);
    super.initState();
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.cliente == null) {
      ClientesController.adicionar(
        ClienteModel(
          id: ClientesController.gerarId(),
          nome: nomeController.text,
          telefone: telefoneController.text,
        ),
      );
    } else {
      ClientesController.atualizar(
        widget.cliente!.copyWith(
          nome: nomeController.text,
          telefone: telefoneController.text,
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
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o telefone' : null,
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
