import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/modulesGlobal/dio.module.dart';
import 'package:mybabernew/core/modulesGlobal/general.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.page.dart';
import 'package:mybabernew/modules/pessoa/pessoa.page.form.dart';


class PessoaModule extends Module {
  static final String ROUTE = "/pessoa";
  static final String ROUTE_PESSOAS_FORM = "/pessoa/pessoa-form";

  @override
  void routes(r) {
    r.child('/', child: (context) => PessoaPage(pessoaController: Modular.get()));
    r.child('/pessoa-form', child: (context) => PessoaFormPage(pessoa: r.args.data,));
  }

  @override
  List<Module> get imports => [
    DioModule(),
    GeneralModule()
  ];
}
