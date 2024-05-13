import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/home/home.page.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/login/login.page.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';
import 'package:mybabernew/pages/splash.dart';

class AppModule extends Module {

  @override
  void binds(i) {
  }

  @override
  List<Module> get imports => [
  ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const Splash());
    r.module(LoginModule.ROUTE, module: LoginModule());
    r.module(HomeModule.ROUTE, module: HomeModule());
    r.module(ConfigModule.ROUTE, module: ConfigModule());
    r.module(ServicoModule.ROUTE, module: ServicoModule());
    r.module(PessoaModule.ROUTE, module: PessoaModule());
    r.module(AgendaModule.ROUTE, module: AgendaModule());
    r.module(GraficoModule.ROUTE, module: GraficoModule());
    r.module(ConfigExpedienteModule.ROUTE, module: ConfigExpedienteModule());
  }
}
