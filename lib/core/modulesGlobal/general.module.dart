import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/login/login.controller.dart';
import 'package:mybabernew/modules/login/login.repository.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.repository.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';
import 'package:mybabernew/modules/servico/servico.repository.dart';

class GeneralModule extends Module {

  @override
  void exportedBinds(i) {
    i.add(ServicoRepository.new);
    i.addSingleton(ServicoController.new);

    i.add(PessoaRepository.new);
    i.addSingleton(PessoaController.new);

    i.add(LoginRepository.new);
    i.addSingleton(LoginController.new);
  }
}