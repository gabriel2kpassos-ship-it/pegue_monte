import 'package:flutter/material.dart';

import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';
import '../../models/cliente_model.dart';
import '../../models/kit_model.dart';
import '../../models/kit_item_model.dart';
import '../clientes/clientes_page.dart';
import '../kits/kits_controller.dart';
import '../produtos/produtos_controller.dart';

class AluguelFormPage extends StatefulWidget {
  const AluguelFormPage({super.key});

  @override
  State<AluguelFormPage> createState() => _AluguelFormPageState();
}

class _AluguelFormPageState extends State<AluguelFormPage> {
  ClienteModel? cliente;
  KitModel? kit;

  DateTime? dataInicio;
  DateTime? dataFim;

  bool salvando = false;

  final AluguelService service = AluguelService();

  bool estoqueSuficiente(KitModel kit) {
    for (final item in kit.itens) {
      final produto = ProdutosController.produtos
          .firstWhere((p) => p.id == item.produtoId);

      if (produto.quantidade < item.quantidade) {
        return false;
      }
    }
    return true;
  }

  Future<void> salvar() async {
    if (salvando) return;

    if (cliente == null ||
        kit == null ||
        dataInicio == null ||
        dataFim == null) {
      _alerta('Preencha todos os campos');
      return;
    }

    if (!estoqueSuficiente(kit!)) {
      _alerta(
        'Um ou mais produtos do kit não possuem estoque suficiente.',
      );
      return;
    }

    setState(() => salvando = true);

    try {
      final aluguel = AluguelModel(
        id: '',
        clienteId: cliente!.id,
        clienteNome: cliente!.nome,
        kitId: kit!.id!,
        kitNome: kit!.nome,
        valor: kit!.preco,
        dataInicio: dataInicio!,
        dataFim: dataFim!,
        itens: kit!.itens,
        status: StatusAluguel.ativo,
      );

      await service.salvarComBaixaEstoque(
        aluguel,
        ProdutosController.produtos,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluguel salvo com sucesso')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      _alerta('Erro ao salvar aluguel:\n$e');
    } finally {
      if (mounted) {
        setState(() => salvando = false);
      }
    }
  }

  void _alerta(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> selecionarCliente() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClientesPage()),
    );

    if (result is ClienteModel) {
      setState(() => cliente = result);
    }
  }

  Future<void> selecionarKit() async {
    final result = await showModalBottomSheet<KitModel>(
      context: context,
      builder: (_) {
        return ListView(
          children: KitsController.kits
              .map(
                (k) => ListTile(
                  title: Text(k.nome),
                  subtitle:
                      Text('R\$ ${k.preco.toStringAsFixed(2)}'),
                  onTap: () => Navigator.pop(context, k),
                ),
              )
              .toList(),
        );
      },
    );

    if (result != null) {
      setState(() => kit = result);
    }
  }

  Future<void> selecionarDataInicio() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => dataInicio = date);
    }
  }

  Future<void> selecionarDataFim() async {
    final date = await showDatePicker(
      context: context,
      firstDate: dataInicio ?? DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: dataInicio ?? DateTime.now(),
    );

    if (date != null) {
      setState(() => dataFim = date);
    }
  }

  Widget itensDoKit() {
    if (kit == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itens do Kit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...kit!.itens.map(
          (KitItemModel item) => ListTile(
            dense: true,
            title: Text(item.produtoNome),
            trailing: Text('Qtd: ${item.quantidade}'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Aluguel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                cliente == null
                    ? 'Selecionar cliente'
                    : cliente!.nome,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: selecionarCliente,
            ),
            const Divider(),
            ListTile(
              title: Text(
                kit == null ? 'Selecionar kit' : kit!.nome,
              ),
              subtitle: kit == null
                  ? null
                  : Text(
                      'R\$ ${kit!.preco.toStringAsFixed(2)}',
                    ),
              trailing: const Icon(Icons.chevron_right),
              onTap: selecionarKit,
            ),
            const Divider(),
            itensDoKit(),
            const Divider(),
            ListTile(
              title: Text(
                dataInicio == null
                    ? 'Data de início'
                    : dataInicio!
                        .toLocal()
                        .toString()
                        .split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: selecionarDataInicio,
            ),
            const Divider(),
            ListTile(
              title: Text(
                dataFim == null
                    ? 'Data de devolução'
                    : dataFim!
                        .toLocal()
                        .toString()
                        .split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: selecionarDataFim,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvando ? null : salvar,
                child: salvando
                    ? const CircularProgressIndicator()
                    : const Text('Confirmar Aluguel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
