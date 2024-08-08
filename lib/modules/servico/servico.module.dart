import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';
import 'package:mybabernew/core/modulesGlobal/general.module.dart';
import 'package:mybabernew/modules/servico/servico.page.dart';
import 'package:mybabernew/modules/servico/servico.page.form.dart';

class ServicoModule extends Module {
  static final String ROUTE = "/servico";
  static final String ROUTE_SERVICOS_FORM = "/servico/servico-form";
  static final String ROUTE_SERVICOS_FORM_EXIBE = "/servico/servico-form/exibe";

  @override
  void routes(r) {
    r.child('/',
        child: (context) => ServicoPage(servicoController: Modular.get()));
    r.child('/servico-form',
        child: (context) => ServicoFormPage(
              servico: r.args.data,
              servicoController: Modular.get(),
            ));
    r.child('/servico-form/exibe',
        child: (context) => ServicoFormPage(
              servico: r.args.data,
              vizualizar: true,
              servicoController: Modular.get(),
            ));
  }

  @override
  List<Module> get imports => [DioModule(), GeneralModule()];
}
