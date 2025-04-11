import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/home/home.controller.dart';
import 'package:mybabernew/modules/home/home.repository.dart';

class HomeModuleGlobal extends Module {

  @override
  void exportedBinds(i) {
    i.add(HomeRepository.new);
    i.addSingleton(HomeController.new);
  }

}