import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/constants.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/login/login.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Store<User> {
  final LoginRepository repo = Modular.get();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;
  late EncryptedSharedPreferences prefsEncrypted;

  LoginController() : super(User());

  Future<User?> buscarUser() async {
    try {
      setLoading(true);
      User? user =
          await repo.getUser(loginController.text, passwordController.text);
      if (user != null) {
        atualizarUser(user);
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

  void unregisterUser() {
    if (GetIt.instance.isRegistered<User>()) {
      GetIt.instance.unregister<User>();
    }
  }

  Future<void> atualizarToken(String login, String password) async {
    log("---atualizando token expirado---");
    User? user = await repo.getUser(login, password);
    if (user != null) {
      if (GetIt.instance.isRegistered<User>()) {
        User userActual = GetIt.instance.get<User>();
        userActual.token = user.token;
        userActual.tokenExpiresIn = user.tokenExpiresIn;
        unregisterUser();
        GetIt.instance.registerSingleton(userActual);
      }
      prefs = await SharedPreferences.getInstance();
      prefs.setString(KEY_TOKEN, user.token!);
      prefs.setString(KEY_EXPIRYTOKENDATE, user.tokenExpiresIn!.toIso8601String());
    }
  }

  Future<void> atualizarUser(User? user) async {
    try {
      setLoading(true);
      if (user != null) {
        unregisterUser();
        GetIt.instance.registerSingleton(user);
        prefs = await SharedPreferences.getInstance();
        prefsEncrypted = EncryptedSharedPreferences();
        prefs.setString(KEY_USERLOGIN, loginController.text);
        prefsEncrypted.setString(KEY_USERPASSWORD, passwordController.text);
        prefs.setString(KEY_USERID, user.userId!);
        prefs.setString(KEY_EXPIRYDATE, user.userExpiresIn!.toIso8601String());
        prefs.setString(KEY_EXPIRYTOKENDATE, user.tokenExpiresIn!.toIso8601String());
        prefs.setString(KEY_TOKEN, user.token!);
        update(user);
      }
    } on DioException catch (e, s) {
      log('Erro ao buscar notificações', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void atualizarPagina() {
    update(state, force: true);
  }

  Future<void> zerarUsuario(bool isLogout) async {
    if (GetIt.instance.isRegistered<User>()) {
      GetIt.instance.unregister<User>();
    }
    if (isLogout) {
      prefsEncrypted = EncryptedSharedPreferences();
      prefs = await SharedPreferences.getInstance();
    }
    prefs.remove(KEY_USERLOGIN);
    prefsEncrypted.remove(KEY_USERPASSWORD);
    prefs.remove(KEY_USERID);
    prefs.remove(KEY_TOKEN);
    prefs.remove(KEY_EXPIRYDATE);
    prefs.remove(KEY_EXPIRYTOKENDATE);
    loginController.text = "";
    passwordController.text = "";
    if (GetIt.instance.isRegistered<User>()) {
      GetIt.instance.unregister<User>();
    }
  }

  Future<void> carregarDadosSessao() async {
    log("---Vai carregar dados da sessão---");
    prefs = await SharedPreferences.getInstance();
    prefsEncrypted = EncryptedSharedPreferences();
    loginController.clear();
    passwordController.clear();
    String? login = prefs.getString(KEY_USERLOGIN);
    String? password = await prefsEncrypted.getString(KEY_USERPASSWORD);
    String? userId = prefs.getString(KEY_USERID);
    String? token = prefs.getString(KEY_TOKEN);
    String? expiresInToIso = prefs.getString(KEY_EXPIRYDATE);
    String? expiresTokenInToIso = prefs.getString(KEY_EXPIRYTOKENDATE);

    if (login != null && login.isNotEmpty) {
      loginController.text = login;
    }
    if (password.isNotEmpty) {
      passwordController.text = password;
    }

    if (loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        token != null &&
        token.isNotEmpty &&
        expiresInToIso != null &&
        expiresInToIso.isNotEmpty) {

      log("---Vai verificar expires do user---");
      DateTime userExpiresIn = DateTime.parse(expiresInToIso);
      if (userExpiresIn.isBefore(DateTime.now())) {
        await zerarUsuario(false);
        return;
      }

      log("---Vai verificar expires do token---");
      DateTime? tokenExpiresIn;
      if (expiresTokenInToIso != null && expiresTokenInToIso.isNotEmpty) {
        tokenExpiresIn = DateTime.parse(expiresTokenInToIso);
        if (tokenExpiresIn.isBefore(DateTime.now())) {
          await atualizarToken(login!, password!);
          token = prefs.getString(KEY_TOKEN);
          expiresTokenInToIso = prefs.getString(KEY_EXPIRYTOKENDATE);
          if (expiresTokenInToIso == null || expiresTokenInToIso.isEmpty) {
            return;
          }
          tokenExpiresIn = DateTime.parse(expiresTokenInToIso);
        }
      }
      User user = User(
        username: login,
        token: token,
        userId: userId,
        userExpiresIn: userExpiresIn,
        tokenExpiresIn: tokenExpiresIn,
      );
      if (GetIt.instance.isRegistered<User>()) {
        GetIt.instance.unregister<User>();
      }
      GetIt.instance.registerSingleton(user);
      Modular.to.pushReplacementNamed(HomeModule.ROUTE);
    }
  }
}
