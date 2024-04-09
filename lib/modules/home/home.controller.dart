import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/notificacao.dart';
import 'package:mybabernew/modules/home/home.repository.dart';

class HomeController extends Store<List<Notificacao>> {
  final HomeRepository homeRepository = Modular.get();

  HomeController() : super([]);

  Future<void> buscarAplicacoes() async {
    try {
      setLoading(true);
      List<Notificacao> aplicacoes = await homeRepository.getApplicacoes();
      update(aplicacoes);
    } on DioException catch (e, s) {
      log('Erro ao buscar notificações', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }


}
