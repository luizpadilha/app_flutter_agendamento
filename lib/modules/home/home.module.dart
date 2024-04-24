import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';
import 'package:mybabernew/core/modulesGlobal/general.module.dart';
import 'package:mybabernew/modules/home/home.controller.dart';
import 'package:mybabernew/modules/home/home.repository.dart';

import 'home.page.dart';

class HomeModule extends Module {
  static final String ROUTE = "/home/";

  @override
  void binds(i) {
    i.add(HomeRepository.new);
    i.addSingleton(HomeController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage(cadastroController: Modular.get()));
  }

  @override
  List<Module> get imports => [DioModule(), GeneralModule()];
}
