import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';
import 'package:mybabernew/modules/graficos/graficos.controller.dart';
import 'package:mybabernew/modules/graficos/graficos.module.global.dart';
import 'package:mybabernew/modules/graficos/graficos.repository.dart';

import 'graficos.page.dart';

class GraficoModule extends Module {
  static final String ROUTE = "/grafico/";

  @override
  void binds(i) {
    i.add(GraficoRepository.new);
    i.addSingleton(GraficoController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => GraficoPage(graficoController: Modular.get()));
  }

  @override
  List<Module> get imports => [DioModuleGlobal(), GraficoModuleGlobal()];
}
