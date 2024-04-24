import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
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

    if (GetIt.instance.isRegistered<User>() && !options.path.contains("/api/auth/login")) {
      User user = GetIt.instance.get<User>();
      options.headers[HttpHeaders.authorizationHeader.toLowerCase()] ='Bearer ${user.token!}';
      options.followRedirects = false;
    }

    options.headers[HttpHeaders.contentTypeHeader] = "application/json";
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
      await _refreshToken();
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

  Future<void> _refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    EncryptedSharedPreferences prefsEncrypted = EncryptedSharedPreferences();
    LoginController loginController = Modular.get();
    String? login = prefs.getString(KEY_USERLOGIN);
    String? password = await prefsEncrypted.getString(KEY_USERPASSWORD);
    if (login != null && login.isNotEmpty && password.isNotEmpty) {
      await loginController.atualizarToken(login, password);
    }
  }

}
