import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/horarios.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/entity/user.dart';

class AgendaRepository {

  final Dio _client = Modular.get();

  Future<List<Agenda>> getAgendas(DateTime data) async {
    User user = GetIt.instance.get<User>();
    var response = await _client
        .get("/api/agenda/agendas?userId=${user.userId}&data=${data.toIso8601String()}");
    if (response.statusCode == 200 && response.data != null) {
      return List<Agenda>.from(
          response.data.map((itemsJson) => Agenda.fromJson(itemsJson)));
    }
    return [];
  }

  Future<List<Horarios>> getHorarios(String servicoId, DateTime data) async {
    User user = GetIt.instance.get<User>();
    var response = await _client
        .get("/api/horario/horarios-por-data?userId=${user.userId}&servicoId=$servicoId&data=${data.toIso8601String()}");
    if (response.statusCode == 200 && response.data != null) {
      return List<Horarios>.from(
          response.data.map((itemsJson) => Horarios.fromJson(itemsJson)));
    }
    return [];
  }

  Future<void> salvarAgendas(
      String id, DateTime horario, Pessoa pessoa, Servico servico) async {
    User user = GetIt.instance.get<User>();
    var response = await _client.post(
      "/api/agenda/salvar-agenda",
      data: jsonEncode({
        'id': id,
        'horarioToIso8601': horario.toIso8601String(),
        'servico': servico.toJson(),
        'pessoa': pessoa.toJson(),
        'userId': user.userId,
      }),
    );
  }

  Future<void> removerAgenda(String id) async {
    var response =
        await _client.post("/api/agenda/remover-agenda?agendaId=$id");
  }
}
