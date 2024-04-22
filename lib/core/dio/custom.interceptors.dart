import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/constants.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/login/login.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptors extends QueuedInterceptorsWrapper {
  final Dio _dio;

  CustomInterceptors(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    String? basePath = baseUrl;
    if (basePath != null && basePath.isNotEmpty && !options.path.contains(basePath)) {
      options.path = (basePath + options.path);
    }

    if (GetIt.instance.isRegistered<User>()) {
      User user = GetIt.instance.get<User>();
      options.headers[HttpHeaders.authorizationHeader.toLowerCase()] ='Bearer ${user.token!}';
      options.followRedirects = false;
    }
    options.headers[HttpHeaders.contentTypeHeader] = "application/json";
    log("REQUEST[${options.method}] => PATH: ${options.path}");
    log("HEADERS[${options.headers}]");

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log("Erro: ${err.response?.data['erro']}");
      await refreshUser();
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        handler.next(e);
      }
      return;
    }
    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    log("---tentando novamente request---");
    final options = Options(
      method: requestOptions.method,
    );

    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshUser() async {
    log("---atualizando token expirado---");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginController loginController = Modular.get();
    loginController.unregisterUser();
    String? login = prefs.getString(KEY_USERLOGIN);
    String? password = prefs.getString(KEY_USERPASSWORD);
    var response = await _dio.post(
      "/api/auth/login",
      data: jsonEncode({
        'login': login,
        'password': password,
      }),
    );
    if (response.data != null && response.data['erro'] == null) {
      var user = User.fromJson(response.data);
      await loginController.atualizarUser(user);
    }
  }

}
