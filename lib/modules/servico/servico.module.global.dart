import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';
import 'package:mybabernew/modules/servico/servico.repository.dart';

class ServicoModuleGlobal extends Module {

  @override
  void exportedBinds(i) {
    i.add(ServicoRepository.new);
    i.addSingleton(ServicoController.new);

  }
}
