import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.controller.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.form.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.page.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.repository.dart';

class ConfigExpedienteModule extends Module {
  static final String ROUTE = "/config-exped";
  static final String ROUTE_CONFIG_EXPD_FORM = "/config-exped/config-exped-form";
  static final String ROUTE_CONFIG_EXPD_FORM_EXIBIR = "/config-exped/config-exped-form/exibir";

  @override
  void binds(i) {
    i.add(ConfigExpedienteRepository.new);
    i.addSingleton(ConfigExpedienteController.new);
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) => ConfigExpedientePage(
              configExpedienteController: Modular.get(),
              configId: r.args.queryParams['idConfig'] as String,
            ));
    r.child('/config-exped-form',
        child: (context) => ConfigExpedienteFormPage(
              configExped: r.args.data,
              idConfig: r.args.queryParams['idConfig'] as String,
              configExpedienteController: Modular.get(),
            ));
    r.child('/config-exped-form/exibir',
        child: (context) => ConfigExpedienteFormPage(
              configExped: r.args.data,
              idConfig: r.args.queryParams['idConfig'] as String,
              configExpedienteController: Modular.get(),
              vizualizar: true,
            ));
  }

  @override
  List<Module> get imports => [DioModuleGlobal()];
}
