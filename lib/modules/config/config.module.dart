import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';
import 'package:mybabernew/modules/config/config.controller.dart';
import 'package:mybabernew/modules/config/config.repository.dart';

import 'config.page.dart';

class ConfigModule extends Module {
  static final String ROUTE = "/config";

  @override
  void binds(i) {
    i.add(ConfigRepository.new);
    i.addSingleton(ConfigController.new);
  }
  @override
  void routes(r) {
    r.child('/', child: (context) => ConfigPage(configController: Modular.get(),));
  }

  @override
  List<Module> get imports => [
    DioModuleGlobal()
  ];
}
