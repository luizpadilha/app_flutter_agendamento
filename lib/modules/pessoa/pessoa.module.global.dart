import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.repository.dart';

class PessoaModuleGlobal extends Module {

  @override
  void exportedBinds(i) {
    i.add(PessoaRepository.new);
    i.addSingleton(PessoaController.new);

  }
}
