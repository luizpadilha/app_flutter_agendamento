import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';

import 'map.page.dart';

class MapModule extends Module {
  static final String ROUTE = "/map";

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => MapPage());
  }

  @override
  List<Module> get imports => [
    DioModule()
  ];
}
