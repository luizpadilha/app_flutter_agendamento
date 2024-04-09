import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/entity/user.dart';

class ServicoRepository {

  final Dio _client = Modular.get();

  Future<List<Servico>> getServicos() async {
    User user = GetIt.instance.get<User>();
    var response =
        await _client.get("/api/servico/servicos?userId=${user.userId}");
    return List<Servico>.from(
        response.data.map((itemsJson) => Servico.fromJson(itemsJson)));
  }

  Future<void> salvarServicos(String id, String descricao, double preco) async {
    User user = GetIt.instance.get<User>();
    var response = await _client.post(
      "/api/servico/salvar-servico",
      data: jsonEncode({
        'id': id,
        'descricao': descricao,
        'preco': preco,
        'userId': user.userId,
      }),
    );
  }

  Future<void> removerServico(String id) async {
    var response = await _client.post("/api/servico/remover-servico?servicoId=$id");
  }
}
