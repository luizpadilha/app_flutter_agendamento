import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/login/login.repository.dart';

class LoginController extends Store<User> {
  final LoginRepository repo = Modular.get();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  LoginController() : super(User());

  Future<User?> getUser() async {
    try {
      setLoading(true);
      User? user =
          await repo.getUser(loginController.text, passwordController.text);
      if (user != null) {
        if (GetIt.instance.isRegistered<User>()) {
          GetIt.instance.unregister<User>();
        }
        GetIt.instance.registerSingleton(user);
        update(user);
        return user;
      }
    } on DioException catch (e, s) {
      log('Erro ao buscar notificações', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
    return null;
  }

  void atualizarPagina() {
    update(state, force: true);
  }
}
