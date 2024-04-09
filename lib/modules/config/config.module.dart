import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';

import 'config.page.dart';

class ConfigModule extends Module {
  static final String ROUTE = "/config";

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => ConfigPage());
  }

  @override
  List<Module> get imports => [
    DioModule()
  ];
}
