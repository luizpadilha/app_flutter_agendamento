import 'package:dio/dio.dart';

import 'dio.interceptors.dart';

class DioInstance {
  final Dio _dio = Dio();

  DioInstance() {
    _dio.interceptors.clear();
    _dio.interceptors.add(DioInterceptors(_dio));
  }

  Dio get dio => _dio;
}
