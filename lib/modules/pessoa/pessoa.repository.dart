import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/user.dart';

class PessoaRepository {

  final Dio _client = Modular.get();

  Future<List<Pessoa>> getPessoas() async {
    User user = GetIt.instance.get<User>();
    var response =
    await _client.get("/api/pessoa/pessoas?userId=${user.userId}");
    return List<Pessoa>.from(
        response.data.map((itemsJson) => Pessoa.fromJson(itemsJson)));
  }

  Future<void> salvarPessoas(String id, String nome, String numero) async {
    User user = GetIt.instance.get<User>();
    var response = await _client.post(
      "/api/pessoa/salvar-pessoa",
      data: jsonEncode({
        'id': id,
        'nome': nome,
        'numero': numero,
        'userId': user.userId,
      }),
    );
  }

  Future<void> removerPessoa(String id) async {
    var response = await _client.post("/api/pessoa/remover-pessoa?pessoaId=$id");
  }
}
