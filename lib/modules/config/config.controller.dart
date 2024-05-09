import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/config.dart';
import 'package:mybabernew/modules/config/config.repository.dart';

class ConfigController extends Store<Config> {

  final ConfigRepository repo = Modular.get();
  String? id;

  ConfigController() : super(Config());

  Future<void> buscarConfiguracao() async {
    try {
      setLoading(true);
      Config config = await repo.getConfig();
      update(config);
    } on DioException catch (e, s) {
      log('Erro ao buscar config', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar config', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void atualizarPagina() {
    update(state, force: true);
  }

  String? getIdConfig() {
    return state.id!;
  }

}
