import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/core/dio/dio.module.global.dart';
import 'package:mybabernew/modules/agenda/agenda.controller.dart';
import 'package:mybabernew/modules/agenda/agenda.page.dart';
import 'package:mybabernew/modules/agenda/agenda.page.form.dart';
import 'package:mybabernew/modules/agenda/agenda.repository.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.global.dart';
import 'package:mybabernew/modules/servico/servico.module.global.dart';

class AgendaModule extends Module {
  static final String ROUTE = "/agenda";
  static final String ROUTE_AGENDA_FORM = "/agenda/agenda-form";
  static final String ROUTE_AGENDA_FORM_EXIBIR = "/agenda/agenda-form/exibir";

  @override
  void binds(i) {
    i.add(AgendaRepository.new);
    i.addSingleton(AgendaController.new);
  }

  @override
  void routes(r) {
    r.child('/',child: (context) => AgendaPage(agendaController: Modular.get()));
    r.child('/agenda-form', child: (context) => AgendaFormPage(
              agenda: r.args.data,
              agendaController: Modular.get(),
            ));
    r.child('/agenda-form/exibir', child: (context) => AgendaFormPage(
      agenda: r.args.data,
      agendaController: Modular.get(),
      vizualizar: true,
    ));
  }

  @override
  List<Module> get imports => [DioModuleGlobal(), ServicoModuleGlobal(), PessoaModuleGlobal()];
}
