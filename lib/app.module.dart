import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';
import 'package:mybabernew/pages/home.page.dart';
import 'package:mybabernew/pages/splash.dart';
import 'package:mybabernew/pages/usuario.page.dart';

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
    r.child('/usuario/', child: (context) => const UsuarioPage());
    r.child(HomePage.ROUTE, child: (context) => const HomePage());
    r.module(LoginModule.ROUTE, module: LoginModule());
    r.module(ConfigModule.ROUTE, module: ConfigModule());
    r.module(ServicoModule.ROUTE, module: ServicoModule());
    r.module(PessoaModule.ROUTE, module: PessoaModule());
    r.module(AgendaModule.ROUTE, module: AgendaModule());
    r.module(GraficoModule.ROUTE, module: GraficoModule());
    r.module(ConfigExpedienteModule.ROUTE, module: ConfigExpedienteModule());
  }
}
