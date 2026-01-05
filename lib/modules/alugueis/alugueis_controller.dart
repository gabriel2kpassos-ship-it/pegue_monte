import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/services/aluguel_service.dart';
import '../../models/aluguel_model.dart';

class AlugueisController extends ChangeNotifier {
  final AluguelService _service = AluguelService();
  StreamSubscription? _sub;

  List<AluguelModel> alugueis = [];
  bool isLoading = true;

  /// OUVIR ALUGUÉIS (🔥 SEM FILTRO)
  void ouvirAlugueis() {
    _sub?.cancel();
    _sub = _service.listarAlugueis().listen((lista) {
      alugueis = lista;
      isLoading = false;
      notifyListeners();
    });
  }

  /// DEVOLVER ALUGUEL
  Future<void> devolverAluguel(AluguelModel aluguel) async {
    await _service.devolverAluguel(aluguel.id);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
