import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/constants.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/exceptions/http_exception.dart';
import 'package:mybabernew/main.dart';

class CustomInterceptors extends QueuedInterceptorsWrapper {
  final Dio _dio;

  CustomInterceptors(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // SharedPreferences.getInstance().then((prefs) {

    String? basePath = baseUrl;
    if (basePath != null && basePath.isNotEmpty) {
      options.path = (basePath + options.path);
    }
    //
    if (GetIt.instance.isRegistered<User>()) {
      User user = GetIt.instance.get<User>();
      options.headers[HttpHeaders.authorizationHeader.toLowerCase()] = 'Bearer ${user.token!}';
      options.followRedirects = false;
    }
    options.headers[HttpHeaders.contentTypeHeader] = "application/json";
    log("REQUEST[${options.method}] => PATH: ${options.path}");
    log("HEADERS[${options.headers}]");
    // });
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
      return super.onError(error, handler);
  }
}
