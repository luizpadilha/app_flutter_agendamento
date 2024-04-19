import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';
import 'package:mybabernew/modules/login/login.controller.dart';
import 'package:mybabernew/modules/login/login.repository.dart';

import 'login.page.dart';

class LoginModule extends Module {
  static final String ROUTE = "/";

  @override
  void binds(i) {
    i.add(LoginRepository.new);
    i.addSingleton(LoginController.new);
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) => LoginPage(
              controller: Modular.get(),
          logout: r.args.data ?? false,
            ));
  }

  @override
  List<Module> get imports => [DioModule()];
}
