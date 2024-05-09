import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/entity/config_expediente.dart';
import 'package:mybabernew/enums/dia_semana.dart';

class ConfigExpedienteRepository {

  final Dio _client = Modular.get();

  Future<List<ConfigExpediente>> getConfigs(String configId) async {
    var response =
    await _client.get("/api/configuracao/configs-expediente?configId=$configId");
    return List<ConfigExpediente>.from(
        response.data.map((itemsJson) => ConfigExpediente.fromJson(itemsJson)));
  }


  Future<void> salvarconfigs(String id, String idConfig, String inicioExpediente, String finalExpediente, String inicioAlmoco, String finalAlmoco, DiaSemana diaSemana) async {
    var response = await _client.post(
      "/api/configuracao/salvar-configs-expediente",
      data: jsonEncode({
        'id': id,
        'idConfig': idConfig,
        'inicioExpediente': inicioExpediente,
        'finalExpediente': finalExpediente,
        'inicioAlmoco': inicioAlmoco,
        'finalAlmoco': finalAlmoco,
        'diaSemana': diaSemana.name,
      }),
    );
  }


}
