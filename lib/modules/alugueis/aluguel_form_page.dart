import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';
import '../../models/kit_model.dart';
import '../../models/cliente_model.dart';

class AluguelFormPage extends StatefulWidget {
  const AluguelFormPage({super.key});

  @override
  State<AluguelFormPage> createState() => _AluguelFormPageState();
}

class _AluguelFormPageState extends State<AluguelFormPage> {
  final _service = AluguelService();

  ClienteModel? _cliente;
  KitModel? _kit;

  DateTime? _dataRetirada;
  DateTime? _dataDevolucao;

  Future<void> _selecionarData(bool retirada) async {
    final data = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (data != null) {
      setState(() {
        retirada ? _dataRetirada = data : _dataDevolucao = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatador = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Aluguel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// CLIENTE
            ListTile(
              title: Text(
                _cliente == null
                    ? 'Selecionar Cliente'
                    : _cliente!.nome,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/clientes-select',
                );

                if (result is ClienteModel) {
                  setState(() => _cliente = result);
                }
              },
            ),

            /// KIT
            ListTile(
              title:
                  Text(_kit == null ? 'Selecionar Kit' : _kit!.nome),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/kits-select',
                );

                if (result is KitModel) {
                  setState(() => _kit = result);
                }
              },
            ),

            const Divider(),

            /// DATAS
            ListTile(
              title: Text(
                _dataRetirada == null
                    ? 'Data de Retirada'
                    : formatador.format(_dataRetirada!),
              ),
              trailing: const Icon(Icons.date_range),
              onTap: () => _selecionarData(true),
            ),
            ListTile(
              title: Text(
                _dataDevolucao == null
                    ? 'Data de Devolução'
                    : formatador.format(_dataDevolucao!),
              ),
              trailing: const Icon(Icons.date_range),
              onTap: () => _selecionarData(false),
            ),

            const SizedBox(height: 24),

            /// SALVAR
            ElevatedButton(
              onPressed: () async {
                if (_cliente == null ||
                    _kit == null ||
                    _dataRetirada == null ||
                    _dataDevolucao == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos'),
                    ),
                  );
                  return;
                }

                final aluguel = AluguelModel(
                  id: '',
                  clienteId: _cliente!.id,
                  clienteNome: _cliente!.nome,
                  kit: _kit!,
                  dataRetirada: _dataRetirada!,
                  dataDevolucao: _dataDevolucao!,
                  valorTotal: _kit!.preco,
                  status: 'ativo',
                );

                try {
                  await _service.criar(aluguel);

                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceAll('Exception: ', ''),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Salvar Aluguel'),
            ),
          ],
        ),
      ),
    );
  }
}
