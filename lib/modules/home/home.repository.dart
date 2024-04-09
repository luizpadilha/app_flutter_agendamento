import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/notificacao.dart';
import 'package:mybabernew/entity/user.dart';


class HomeRepository {

  final Dio _client = Modular.get();

  Future<List<Notificacao>> getApplicacoes() async {
    try {
      User user = GetIt.instance.get<User>();
      var response = await _client.get("/api/notificacao/notificacoes?userId=${user.userId}");
      return List<Notificacao>.from(
          response.data.map((itemsJson) => Notificacao.fromJson(itemsJson)));
    } on DioException catch (e) {
      log("Error ${e} ");
      rethrow;
    }
  }
}
