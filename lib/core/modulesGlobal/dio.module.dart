import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/custom.dio.dart';

class DioModule extends Module {

  @override
  void exportedBinds(i) {
    i.addInstance<Dio>(CustomDio().dio);
  }
}