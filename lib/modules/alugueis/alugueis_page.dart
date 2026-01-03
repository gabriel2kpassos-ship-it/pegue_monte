import 'package:flutter/material.dart';

import '../../core/services/aluguel_service.dart';
import '../../core/services/cliente_service.dart';
import '../../core/services/kit_service.dart';
import '../../core/services/produto_service.dart';

import '../../models/aluguel_model.dart';
import '../../models/cliente_model.dart';
import '../../models/kit_model.dart';

class AlugueisPage extends StatefulWidget {
  const AlugueisPage({super.key});

  @override
  State<AlugueisPage> createState() => _AlugueisPageState();
}

class _AlugueisPageState extends State<AlugueisPage> {
  final aluguelService = AluguelService();
  final clienteService = ClienteService();
  final kitService = KitService();
  final produtoService = ProdutoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aluguéis')),
      body: StreamBuilder<List<AluguelModel>>(
        stream: aluguelService.listar(),
        builder: (_, aluguelSnap) {
          if (aluguelSnap.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (!aluguelSnap.hasData ||
              aluguelSnap.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum aluguel registrado'),
            );
          }

          return StreamBuilder<List<ClienteModel>>(
            stream: clienteService.listar(),
            builder: (_, clienteSnap) {
              if (!clienteSnap.hasData) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              final clientes = {
                for (final c in clienteSnap.data!) c.id: c
              };

              return StreamBuilder<List<KitModel>>(
                stream: kitService.listar(),
                builder: (_, kitSnap) {
                  if (!kitSnap.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final kits = {
                    for (final k in kitSnap.data!) k.id: k
                  };

                  return ListView.builder(
                    itemCount: aluguelSnap.data!.length,
                    itemBuilder: (_, i) {
                      final aluguel = aluguelSnap.data![i];
                      final cliente =
                          clientes[aluguel.clienteId];
                      final kit = kits[aluguel.kitId];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                cliente?.nome ??
                                    'Cliente removido',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kit: ${kit?.nome ?? 'Kit removido'}',
                              ),
                              const SizedBox(height: 6),
                              if (kit != null)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: kit.itens.map((item) {
                                    final produto =
                                        produtoService.getById(
                                            item.produtoId);
                                    return Text(
                                      '- ${produto?.nome ?? 'Produto removido'} '
                                      '(Qtd: ${item.quantidade})',
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                'Data: ${aluguel.data.day}/${aluguel.data.month}/${aluguel.data.year}',
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
