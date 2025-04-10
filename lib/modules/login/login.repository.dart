import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/exceptions/http_exception.dart';
import 'package:mybabernew/exceptions/my.exception.dart';

class LoginRepository {

  final Dio _client = Modular.get();


  Future<Map<String, dynamic>> gerarTokenAndRetornaUser(String login, String pass, String pathApi, {bool isRegisteredUser = true}) async {
    try {
      String path = isRegisteredUser ? '' : pathApi;
      var response = await _client.post(
        "$path/api/auth/login",
        data: jsonEncode({
          'login': login,
          'password': pass,
        }),
      );
      if (response.statusCode == 200 && response.data != null && response.data['erro'] == null) {
        return response.data;
      }
      if (response.data['erro'] != null) {
        var erro = response.data['erro'] as String;
        throw MyException(msg: erro);
      }
    } catch (erro) {
      log("Error ${erro} ");
      rethrow;
    }
    throw MyException(msg: 'Erro inesperado para gerar token');
  }
}
