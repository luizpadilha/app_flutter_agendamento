import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/exceptions/http_exception.dart';

class LoginRepository {

  final Dio _client = Modular.get();


  Future<User?> getUser(String login, String pass) async {
    try {
      var response = await _client.post(
        "/api/auth/login",
        data: jsonEncode({
          'login': login,
          'password': pass,
        }),
      );
      if (response.data != null && response.data['erro'] == null) {
        var user = User.fromJson(response.data);
        return user;
      }

      if (response.data['erro'] != null) {
        var erro = response.data['erro'] as String;
        var codigo = response.data['codigo'] as int;
        throw HttpException(msg: erro, statusCode: codigo);
      }
      return null;
    } on DioException catch (e) {
      log("Error ${e} ");
      rethrow;
    }
  }
}
