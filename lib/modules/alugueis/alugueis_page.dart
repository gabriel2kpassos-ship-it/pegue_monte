import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';
import 'aluguel_form_page.dart';

class AlugueisPage extends StatefulWidget {
  const AlugueisPage({super.key});

  @override
  State<AlugueisPage> createState() => _AlugueisPageState();
}

class _AlugueisPageState extends State<AlugueisPage> {
  final _aluguelService = AluguelService();
  final _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

  void _novoAluguel() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AluguelFormPage()),
    );
    setState(() {});
  }

  void _confirmarDevolucao(AluguelModel aluguel) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar devolução'),
        content: const Text(
          'Deseja finalizar este aluguel e devolver os produtos ao estoque?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      _aluguelService.finalizarAluguel(aluguel.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluguel finalizado')),
      );
    }
  }

  bool _estaAtrasado(AluguelModel aluguel) {
    final hoje = DateTime.now();
    return aluguel.status == AluguelStatus.ativo &&
        hoje.isAfter(aluguel.dataDevolucao);
  }

  @override
  Widget build(BuildContext context) {
    final alugueis = _aluguelService.listar();

    return Scaffold(
      appBar: AppBar(title: const Text('Aluguéis')),
      floatingActionButton: FloatingActionButton(
        onPressed: _novoAluguel,
        child: const Icon(Icons.add),
      ),
      body: alugueis.isEmpty
          ? const Center(child: Text('Nenhum aluguel cadastrado'))
          : ListView.builder(
              itemCount: alugueis.length,
              itemBuilder: (_, index) {
                final aluguel = alugueis[index];
                final ativo = aluguel.status == AluguelStatus.ativo;
                final atrasado = _estaAtrasado(aluguel);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: atrasado ? Colors.red.shade50 : null,
                  child: ListTile(
                    title: Text(aluguel.clienteNome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kit: ${aluguel.kitNome}'),
                        Text(
                          'Período: '
                          '${_dateFormat.format(aluguel.dataInicio)} '
                          '→ ${_dateFormat.format(aluguel.dataDevolucao)}',
                        ),
                        if (atrasado)
                          const Text(
                            '⚠ Aluguel em atraso',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          Text(
                            'Status: ${ativo ? 'Ativo' : 'Finalizado'}',
                            style: TextStyle(
                              color: ativo ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    trailing: ativo
                        ? IconButton(
                            icon: const Icon(Icons.assignment_return),
                            tooltip: 'Finalizar aluguel',
                            onPressed: () =>
                                _confirmarDevolucao(aluguel),
                          )
                        : const Icon(Icons.check, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
