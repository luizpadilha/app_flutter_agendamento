import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/config_expediente.dart';
import 'package:mybabernew/enums/dia_semana.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.repository.dart';
import 'package:mybabernew/utils/time_day_util.dart';

class ConfigExpedienteController extends Store<List<ConfigExpediente>> {

  final ConfigExpedienteRepository repo = Modular.get();
  TimeOfDay? inicioExpediente;
  TimeOfDay? finalExpediente;
  TimeOfDay? inicioAlmoco;
  TimeOfDay? finalAlmoco;
  DiaSemana? diaSemana;
  String? id;
  String? idConfig;

  ConfigExpedienteController() : super([]);

  Future<void> buscarConfiguracoes(String configId) async {
    try {
      setLoading(true);
      List<ConfigExpediente> configs = await repo.getConfigs(configId);
      update(configs);
    } on DioException catch (e, s) {
      log('Erro ao buscar configs', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar configs', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> salvarConfiguracoes() async {
    try {
      setLoading(true);
      await repo.salvarconfigs(
        id!,
        idConfig!,
        TimeDayUtil.converterTimeOfDayToString(inicioExpediente!),
        TimeDayUtil.converterTimeOfDayToString(finalExpediente!),
        TimeDayUtil.converterTimeOfDayToString(inicioAlmoco!),
        TimeDayUtil.converterTimeOfDayToString(finalAlmoco!),
        diaSemana!,
      );
    } on DioException catch (e, s) {
      log('Erro ao salvar config', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void atualizarPagina() {
    update(state, force: true);
  }

}
