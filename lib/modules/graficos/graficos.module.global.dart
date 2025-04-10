import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';
import 'package:mybabernew/modules/graficos/graficos.controller.dart';
import 'package:mybabernew/modules/graficos/graficos.repository.dart';

import 'graficos.page.dart';

class GraficoModuleGlobal extends Module {

  @override
  void exportedBinds(i) {
    i.add(GraficoRepository.new);
    i.addSingleton(GraficoController.new);
  }

}
