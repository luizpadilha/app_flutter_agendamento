import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';
import 'package:mybabernew/core/modulesGlobal/general.module.dart';
import 'package:mybabernew/modules/servico/servico.page.dart';
import 'package:mybabernew/modules/servico/servico.page.form.dart';


class ServicoModule extends Module {
  static final String ROUTE = "/servico";
  static final String ROUTE_SERVICOS_FORM = "/servico/servico-form";

  @override
  void routes(r) {
    r.child('/', child: (context) => ServicoPage(servicoController: Modular.get()));
    r.child('/servico-form', child: (context) => ServicoFormPage(servico: r.args.data,));
  }

  @override
  List<Module> get imports => [
    DioModule(),
    GeneralModule()
  ];
}
