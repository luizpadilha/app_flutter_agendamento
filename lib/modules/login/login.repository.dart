import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/entity/user.dart';

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
      log(response.data.toString());
      if (response.data != null && response.data['erro'] == null) {
        var user = User.fromJson(response.data);
        return user;
      }
      return null;
    } on DioException catch (e) {
      log("Error ${e} ");
      rethrow;
    }
  }
}
