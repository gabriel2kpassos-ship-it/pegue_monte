import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/aluguel_service.dart';
import '../../core/services/cliente_service.dart';
import '../../core/services/kit_service.dart';
import '../../models/aluguel_model.dart';
import '../../models/cliente_model.dart';
import '../../models/kit_model.dart';

class AluguelFormPage extends StatefulWidget {
  const AluguelFormPage({super.key});

  @override
  State<AluguelFormPage> createState() => _AluguelFormPageState();
}

class _AluguelFormPageState extends State<AluguelFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _aluguelService = AluguelService();
  final _clienteService = ClienteService();
  final _kitService = KitService();

  List<ClienteModel> _clientes = [];
  List<KitModel> _kits = [];

  ClienteModel? _cliente;
  KitModel? _kit;

  DateTime? _inicio;
  DateTime? _fim;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    _clientes = await _clienteService.listarClientes().first;
    _kits = await _kitService.listarKits().first;
    setState(() {});
  }

  Future<void> _selecionarDataInicio() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data != null) setState(() => _inicio = data);
  }

  Future<void> _selecionarDataFim() async {
    if (_inicio == null) return;
    final data = await showDatePicker(
      context: context,
      initialDate: _inicio!.add(const Duration(days: 1)),
      firstDate: _inicio!.add(const Duration(days: 1)),
      lastDate: _inicio!.add(const Duration(days: 365)),
    );
    if (data != null) setState(() => _fim = data);
  }

  Future<void> _salvar() async {
    if (_cliente == null || _kit == null || _inicio == null || _fim == null) {
      return;
    }

    setState(() => _salvando = true);

    final aluguel = AluguelModel(
      id: '',
      clienteId: _cliente!.id,
      clienteNome: _cliente!.nome,
      kitId: _kit!.id,
      kitNome: _kit!.nome,
      dataInicio: _inicio!,
      dataFim: _fim!,
      valorTotal: _kit!.preco,
      status: AluguelStatus.ativo,
    );

    await _aluguelService.criarAluguel(aluguel);

    if (mounted) Navigator.pop(context);
  }

  String _fmt(DateTime? d) =>
      d == null ? '--/--/----' : DateFormat('dd/MM/yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Aluguel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<ClienteModel>(
                hint: const Text('Cliente'),
                initialValue: _cliente,
                items: _clientes
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.nome),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _cliente = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<KitModel>(
                hint: const Text('Kit'),
                initialValue: _kit,
                items: _kits
                    .map((k) => DropdownMenuItem(
                          value: k,
                          child: Text(k.nome),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _kit = v),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Data início'),
                subtitle: Text(_fmt(_inicio)),
                onTap: _selecionarDataInicio,
              ),
              ListTile(
                title: const Text('Data devolução'),
                subtitle: Text(_fmt(_fim)),
                onTap: _selecionarDataFim,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _salvando ? null : _salvar,
                child: const Text('Salvar Aluguel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
