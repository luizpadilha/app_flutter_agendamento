import 'package:dio/dio.dart';

import 'custom.interceptors.dart';

class CustomDio {
  final Dio _dio = Dio();

  CustomDio() {
    _dio.interceptors.clear();
    _dio.interceptors.add(CustomInterceptors(_dio));
    // _dio.options.connectTimeout = 50000;
  }

  Dio get dio => _dio;
}
