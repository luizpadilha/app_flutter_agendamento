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

class DioInterceptors extends QueuedInterceptorsWrapper {

  final Dio _dio;

  DioInterceptors(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? basePath = baseUrl;
    if (basePath != null &&
        basePath.isNotEmpty &&
        !options.path.contains(basePath)) {
      options.path = (basePath + options.path);
    }

    if (GetIt.instance.isRegistered<User>() && !options.path.contains("/api/auth/login")) {
      User user = GetIt.instance.get<User>();
      options.headers[HttpHeaders.authorizationHeader.toLowerCase()] = 'Bearer ${user.token}';
      options.followRedirects = false;
    }

    options.headers[HttpHeaders.contentTypeHeader] = "application/json";
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      bool hasNovoToken = await _refreshToken();
      if (!hasNovoToken) {
        handler.next(err);
        return;
      }
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
    try {
      log("---tentando novamente request---");
      final options = Options(method: requestOptions.method);
      Response response = await _dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      log("---request repetido com sucesso---");
      return response;
    } catch (e) {
      log('Erro no _retry: $e');
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    log("---atualizando token---");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      EncryptedSharedPreferences prefsEncrypted = EncryptedSharedPreferences();
      LoginController loginController = Modular.get();
      String? login = prefs.getString(KEY_USERLOGIN);
      String? password = await prefsEncrypted.getString(KEY_USERPASSWORD);
      String? expiresInToIso = prefs.getString(KEY_EXPIRYDATE);

      if (login != null && login.isNotEmpty && password.isNotEmpty && expiresInToIso != null && expiresInToIso.isNotEmpty) {
        DateTime userExpiresIn = DateTime.parse(expiresInToIso);
        await loginController.atualizarUserApi(login, password, userExpiresIn);
      }
      return true;
    } catch (e) {
      log('Erro no _refreshToken: $e');
      return false;
    }
  }
}
