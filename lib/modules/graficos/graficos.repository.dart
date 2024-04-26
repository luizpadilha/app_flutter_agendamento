import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/grafico.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/enums/tipo_periodo_grafico.dart';

class GraficoRepository {
  final Dio _client = Modular.get();

  Future<List<Grafico>> getGraficoPorPeriodo(String dataInicial, String dataFinal, TipoPeriodoGrafico tipoPeriodoGrafico) async {
    try {
      User user = GetIt.instance.get<User>();
      Map<String, dynamic> queryParams = {
        'userId': user.userId,
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
        'tipoPeriodo': tipoPeriodoGrafico.name,
      };
      var response = await _client.get(
        "/api/grafico/grafico-por-periodo",
          queryParameters: queryParams,
      );
      return List<Grafico>.from(
          response.data.map((itemsJson) => Grafico.fromJson(itemsJson)));
    } on DioException catch (e) {
      log("Error ${e} ");
      rethrow;
    }
  }
}
