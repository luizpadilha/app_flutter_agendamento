import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.instance.dart';
import 'package:mybabernew/modules/login/login.controller.dart';
import 'package:mybabernew/modules/login/login.repository.dart';

class DioModuleGlobal extends Module {

  @override
  void exportedBinds(i) {
    i.addInstance<Dio>(DioInstance().dio);
    i.add(LoginRepository.new);
    i.addSingleton(LoginController.new);
  }
}