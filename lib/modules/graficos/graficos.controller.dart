import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/entity/grafico.dart';
import 'package:mybabernew/enums/tipo_periodo_grafico.dart';
import 'package:mybabernew/modules/graficos/graficos.repository.dart';

class GraficoController extends Store<List<Grafico>> {

  static final DateTime now = DateTime.now();
  static late DateTime _startDate = now.subtract(Duration(days: now.weekday - 1));
  static late DateTime _endDate = _startDate.add(const Duration(days: 6));
  DateTimeRange periodo = DateTimeRange(start: _startDate, end: _endDate);
  TipoPeriodoGrafico tipoPeriodoGrafico = TipoPeriodoGrafico.SEMANA;
  int ano = DateTime.now().year;

  final GraficoRepository graficoRepository = Modular.get();

  GraficoController() : super([]);

  Future<void> buscarDadosGrafico() async {
    try {
      setLoading(true);
      await atribuirPeriodoPorSemestre();
      List<Grafico> dados = await graficoRepository.getGraficoPorPeriodo(periodo.start.toIso8601String(), periodo.end.toIso8601String(), tipoPeriodoGrafico);
      update(dados);
    } on DioException catch (e, s) {
      log('Erro ao buscar grafico', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar grafico', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> atribuirPeriodoPorSemestre() async {
    if (TipoPeriodoGrafico.SEMESTRE1 == tipoPeriodoGrafico) {
      DateTime semestre1Inicio = DateTime(ano, 1, 1);
      DateTime semestre1Fim = DateTime(ano, 6 + 1, 0);
      periodo = DateTimeRange(start: semestre1Inicio, end: semestre1Fim);
    } else if (TipoPeriodoGrafico.SEMESTRE2 == tipoPeriodoGrafico) {
      DateTime semestre2Inicio = DateTime(ano, 7, 1);
      DateTime semestre2Fim = DateTime(ano, 12 + 1, 0);
      periodo = DateTimeRange(start: semestre2Inicio, end: semestre2Fim);
    }
  }

  void atribuirPeriodoSemanaAtual() {
    periodo = DateTimeRange(start: _startDate, end: _endDate);
  }

  String get titleGraficoPorPeriodo {
    switch (tipoPeriodoGrafico) {
      case TipoPeriodoGrafico.SEMANA:
        return 'Semana '
            '${DateFormat('dd/MM').format(periodo.start)}'
            ' - '
            '${DateFormat('dd/MM').format(periodo.end)}';
      case TipoPeriodoGrafico.SEMESTRE1:
        return '1º Semestre';
      case TipoPeriodoGrafico.SEMESTRE2:
        return '2º Semestre';
      default:
        return '';
    }
  }


}
