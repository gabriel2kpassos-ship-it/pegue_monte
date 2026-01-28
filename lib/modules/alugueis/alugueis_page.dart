import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/aluguel_model.dart';
import 'alugueis_controller.dart';
import 'aluguel_form_page.dart';

class AlugueisPage extends StatelessWidget {
  const AlugueisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlugueisController()..ouvirAlugueis(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aluguéis'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AluguelFormPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<AlugueisController>(
          builder: (_, controller, __) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.alugueis.isEmpty) {
              return const Center(child: Text('Nenhum aluguel encontrado'));
            }

            final lista = controller.alugueis;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: lista.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final aluguel = lista[i];
                return _AluguelCard(
                  aluguel: aluguel,
                  onDevolver: aluguel.status == AluguelStatus.ativo
                      ? () async {
                          try {
                            await controller.devolverAluguel(aluguel);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aluguel devolvido.'),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao devolver: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AluguelCard extends StatelessWidget {
  final AluguelModel aluguel;
  final Future<void> Function()? onDevolver;

  const _AluguelCard({
    required this.aluguel,
    required this.onDevolver,
  });

  bool get _estaAtrasado {
    // REGRA DE NEGÓCIO:
    // agora > dataFim e status ativo => atrasado
    if (aluguel.status != AluguelStatus.ativo) return false;
    final now = DateTime.now();
    return now.isAfter(aluguel.dataFim);
  }

  String _statusLabel() {
    if (_estaAtrasado) return 'Atrasado';
    switch (aluguel.status) {
      case AluguelStatus.ativo:
        return 'Ativo';
      case AluguelStatus.devolvido:
        return 'Devolvido';
    }
  }

  IconData _statusIcon() {
    if (_estaAtrasado) return Icons.warning_amber_rounded;
    switch (aluguel.status) {
      case AluguelStatus.ativo:
        return Icons.schedule;
      case AluguelStatus.devolvido:
        return Icons.check_circle;
    }
  }

  Color? _statusColor(BuildContext context) {
    if (_estaAtrasado) return Colors.red;
    switch (aluguel.status) {
      case AluguelStatus.ativo:
        return Theme.of(context).colorScheme.primary;
      case AluguelStatus.devolvido:
        return Colors.green;
    }
  }

  String _fmtDate(DateTime d) {
    // intl: seguro no Web/Mobile
    // (formato numérico não depende de locale carregado)
    return DateFormat('dd/MM/yyyy').format(d);
  }

  String _periodoLabel() {
    final ini = _fmtDate(aluguel.dataInicio);
    final fim = _fmtDate(aluguel.dataFim);
    return '$ini → $fim';
  }

  String? _atrasoLabel() {
    if (!_estaAtrasado) return null;

    final now = DateTime.now();
    final diff = now.difference(aluguel.dataFim);

    // arredonda pra dias "humanos"
    final dias = (diff.inHours / 24).ceil();
    final d = dias <= 1 ? 'dia' : 'dias';
    return 'Atraso: $dias $d';
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusLabel();
    final statusColor = _statusColor(context);
    final atraso = _atrasoLabel();

    final borderSide = _estaAtrasado
        ? const BorderSide(color: Colors.red, width: 1.6)
        : BorderSide(color: Theme.of(context).dividerColor, width: 1);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: borderSide,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone de status
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (statusColor ?? Colors.grey).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _statusIcon(),
                color: statusColor,
              ),
            ),
            const SizedBox(width: 12),

            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aluguel.clienteNome.isNotEmpty
                        ? aluguel.clienteNome
                        : 'Cliente',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    aluguel.kitNome.isNotEmpty ? aluguel.kitNome : 'Kit',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Datas
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _periodoLabel(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Status + atraso
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _ChipStatus(
                        label: status,
                        color: statusColor ?? Colors.grey,
                      ),
                      if (atraso != null)
                        _ChipStatus(
                          label: atraso,
                          color: Colors.red,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Ações
            if (onDevolver != null)
              IconButton(
                tooltip: 'Marcar como devolvido',
                onPressed: onDevolver,
                icon: const Icon(Icons.assignment_turned_in),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.check, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChipStatus extends StatelessWidget {
  final String label;
  final Color color;

  const _ChipStatus({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
