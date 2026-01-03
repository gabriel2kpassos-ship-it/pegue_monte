import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/aluguel_service.dart';
import '../../core/services/cliente_service.dart';
import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';
import '../../models/aluguel_model.dart';
import '../../models/cliente_model.dart';
import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';

class AluguelFormPage extends StatefulWidget {
  const AluguelFormPage({super.key});

  @override
  State<AluguelFormPage> createState() => _AluguelFormPageState();
}

class _AluguelFormPageState extends State<AluguelFormPage> {
  final _clienteService = ClienteService();
  final _kitService = KitService();
  final _produtoService = ProdutoService();
  final _aluguelService = AluguelService();

  final _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

  ClienteModel? _clienteSelecionado;
  KitModel? _kitSelecionado;

  DateTime? _dataInicio;
  DateTime? _dataDevolucao;

  bool _salvando = false;

  Future<void> _selecionarDataInicio() async {
    final data = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _dataInicio = data;
        _dataDevolucao = null; // 🔑 reseta devolução
      });
    }
  }

  Future<void> _selecionarDataDevolucao() async {
    if (_dataInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione primeiro a data de início'),
        ),
      );
      return;
    }

    final data = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: _dataInicio!.add(const Duration(days: 1)),
      lastDate: _dataInicio!.add(const Duration(days: 365)),
      initialDate: _dataInicio!.add(const Duration(days: 1)),
    );

    if (data != null) {
      setState(() => _dataDevolucao = data);
    }
  }

  bool _estoqueSuficiente(KitModel kit) {
    for (final KitItemModel item in kit.itens) {
      if (!_produtoService.temEstoque(
        item.produtoId,
        item.quantidade,
      )) {
        return false;
      }
    }
    return true;
  }

  void _confirmar() async {
    if (_clienteSelecionado == null ||
        _kitSelecionado == null ||
        _dataInicio == null ||
        _dataDevolucao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    if (!_estoqueSuficiente(_kitSelecionado!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Estoque insuficiente para um ou mais itens do kit'),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final aluguel = AluguelModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clienteId: _clienteSelecionado!.id,
      clienteNome: _clienteSelecionado!.nome,
      kitId: _kitSelecionado!.id,
      kitNome: _kitSelecionado!.nome,
      kitPreco: _kitSelecionado!.preco,
      itens: List.from(_kitSelecionado!.itens),
      dataInicio: _dataInicio!,
      dataDevolucao: _dataDevolucao!,
      status: AluguelStatus.ativo,
    );

    _aluguelService.adicionar(aluguel);

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final clientes = _clienteService.listar();
    final kits = _kitService.listar();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Aluguel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<ClienteModel>(
              initialValue: _clienteSelecionado,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: clientes
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.nome),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _clienteSelecionado = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<KitModel>(
              initialValue: _kitSelecionado,
              decoration: const InputDecoration(labelText: 'Kit'),
              items: kits
                  .map((k) => DropdownMenuItem(
                        value: k,
                        child: Text(k.nome),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _kitSelecionado = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _dataInicio == null
                    ? 'Selecionar data de início'
                    : 'Início: ${_dateFormat.format(_dataInicio!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarDataInicio,
            ),
            ListTile(
              title: Text(
                _dataDevolucao == null
                    ? 'Selecionar data de devolução'
                    : 'Devolução: ${_dateFormat.format(_dataDevolucao!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarDataDevolucao,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvando ? null : _confirmar,
              child: _salvando
                  ? const CircularProgressIndicator()
                  : const Text('Confirmar Aluguel'),
            ),
          ],
        ),
      ),
    );
  }
}
