import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/home/home.module.global.dart';
import 'package:mybabernew/modules/home/home.page.dart';

class HomeModule extends Module {
  static const String ROUTE = "/home/";

  @override
  void routes(r) {
    r.child('/',
      child: (context) => HomePage(
              controller: Modular.get(),
            ),
      transition: TransitionType.fadeIn,
    );
  }

  @override
  List<Module> get imports => [
    HomeModuleGlobal(),
  ];
}
