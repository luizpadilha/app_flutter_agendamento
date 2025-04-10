import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/modules/home/home.repository.dart';
import 'package:mybabernew/modules/viewobject/home.dart';

class HomeController extends Store<Home> {
  final HomeRepository repo = Modular.get();

  HomeController() : super(Home());

  Future<void> initPage() async {}

  void atualizarPagina() {
    update(state, force: true);
  }
}
