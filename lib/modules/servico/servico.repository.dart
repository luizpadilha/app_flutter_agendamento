import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/entity/user.dart';

class ServicoRepository {

  final Dio _client = Modular.get();

  Future<List<Servico>> getServicos() async {
    User user = GetIt.instance.get<User>();
    var response = await _client.get("/api/servico/servicos?userId=${user.userId}");

    List<Future<Servico>> servicosFutures = response.data
        .map<Future<Servico>>((itemsJson) => Servico.fromJson(itemsJson))
        .toList();

    return Future.wait(servicosFutures);
  }

  Future<void> salvarServicos(String id, String descricao, double preco, String tempo, File? image) async {
    String? imageBase64;
    if (image != null) {
      List<int> fileBytes = await image.readAsBytes();
      imageBase64 = base64Encode(fileBytes);
    }
    User user = GetIt.instance.get<User>();
    var response = await _client.post(
      "/api/servico/salvar-servico",
      data: jsonEncode({
        'id': id,
        'descricao': descricao,
        'preco': preco,
        'userId': user.userId,
        'tempo': tempo,
        'imageBase64': imageBase64,
      }),
    );
  }

  Future<void> removerServico(String id) async {
    var response = await _client.post("/api/servico/remover-servico?servicoId=$id");
  }
}
