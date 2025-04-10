import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';

import 'login.page.dart';

class LoginModule extends Module {
  static final String ROUTE = "/login/";

  @override
  void binds(i) {
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
  List<Module> get imports => [DioModuleGlobal()];
}
