import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/constants.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/login/login.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Store<User> {
  final LoginRepository repo = Modular.get();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;

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
        prefs = await SharedPreferences.getInstance();
        prefs.setString(KEY_USERLOGIN, loginController.text);
        prefs.setString(KEY_USERPASSWORD, passwordController.text);
        prefs.setString(KEY_USERID, user.userId!);
        prefs.setString(KEY_EXPIRYDATE, user.expiresIn!);
        prefs.setString(KEY_TOKEN, user.token!);

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

  void zerarUsuario() {
    if (GetIt.instance.isRegistered<User>()) {
      GetIt.instance.unregister<User>();
    }
    prefs.setString(KEY_USERLOGIN, "");
    prefs.setString(KEY_USERPASSWORD, "");
    prefs.setString(KEY_USERID, "");
    prefs.setString(KEY_EXPIRYDATE, "");
    prefs.setString(KEY_TOKEN, "");
    loginController.text = "";
    passwordController.text = "";
  }

  Future<void> carregarDadosSessao() async {
    log("Vai carregar dados da sessão -----------------");
    prefs = await SharedPreferences.getInstance();
    loginController.clear();
    passwordController.clear();
    String? login = prefs.getString(KEY_USERLOGIN);
    String? password = prefs.getString(KEY_USERPASSWORD);
    String? token = prefs.getString(KEY_TOKEN);
    String? expiresIn = prefs.getString(KEY_EXPIRYDATE);
    String? userId = prefs.getString(KEY_USERID);

    if (login != null && login.isNotEmpty) {
      loginController.text = login;
    }
    if (password != null && password.isNotEmpty) {
      passwordController.text = password;
    }

    if (loginController.text.isNotEmpty && passwordController.text.isNotEmpty && token != null && token.isNotEmpty && expiresIn != null && expiresIn.isNotEmpty) {
      User user = User(username: login, token: token, userId: userId, expiresIn: expiresIn);
      if (GetIt.instance.isRegistered<User>()) {
        GetIt.instance.unregister<User>();
      }
      GetIt.instance.registerSingleton(user);
      Modular.to.pushReplacementNamed(HomeModule.ROUTE);
    }
  }


}
