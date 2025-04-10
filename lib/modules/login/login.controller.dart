import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
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
  late EncryptedSharedPreferences prefsEncrypted;

  LoginController() : super(User());

  Future<void> buscarUser() async {
    try {
      setLoading(true);
      await atualizarUserApi(loginController.text, passwordController.text, null);
      Modular.to.pushReplacementNamed(HomeModule.ROUTE);
    } catch (erro) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void unregisterUser() {
    if (GetIt.instance.isRegistered<User>()) {
      GetIt.instance.unregister<User>();
    }
  }

  Future<void> atualizarSessaoUser(User user) async {
    try {
      unregisterUser();
      GetIt.instance.registerSingleton(user);
      prefs = await SharedPreferences.getInstance();
      prefsEncrypted = EncryptedSharedPreferences();
      prefs.setString(KEY_USERLOGIN, loginController.text);
      prefsEncrypted.setString(KEY_USERPASSWORD, passwordController.text);
      prefs.setString(KEY_EXPIRYDATE, user.userExpiresIn!.toIso8601String());
      update(user);
    } on DioException catch (e, s) {
      log('Erro ao atualizar sessao user', error: e, stackTrace: s);
      rethrow;
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
    prefs.remove(KEY_EXPIRYDATE);
    loginController.text = "";
    passwordController.text = "";
  }

  Future<void> carregarDadosSessao() async {
    log("---Vai carregar dados da sessão---");
    prefs = await SharedPreferences.getInstance();
    prefsEncrypted = EncryptedSharedPreferences();
    loginController.clear();
    passwordController.clear();
    String? login = prefs.getString(KEY_USERLOGIN);
    String? password = await prefsEncrypted.getString(KEY_USERPASSWORD);
    String? expiresInToIso = prefs.getString(KEY_EXPIRYDATE);

    if (login != null && login.isNotEmpty) {
      loginController.text = login;
    }
    if (password != null && password.isNotEmpty) {
      passwordController.text = password;
    }

    if (loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        expiresInToIso != null &&
        expiresInToIso.isNotEmpty) {
      log("---Vai verificar expires do user---");
      DateTime userExpiresIn = DateTime.parse(expiresInToIso);
      if (userExpiresIn.isBefore(DateTime.now())) {
        await zerarUsuario(false);
        return;
      }
      await atualizarUserApi(loginController.text, passwordController.text, userExpiresIn);
      Modular.to.pushReplacementNamed(HomeModule.ROUTE);
    }
  }

  Future<void> atualizarUserApi(String username, String password, DateTime? userExpiresIn) async {
    log("---gerar token---");
    try {
      Map<String, dynamic> dados = await repo.gerarTokenAndRetornaUser(username, password, baseUrl, isRegisteredUser: isRegisteredUser());
      User user = User(username: username);
      user.token = dados['token'];
      user.userId = dados['userId'];
      int expires = int.parse(dados['expiresIn'].toString());
      user.tokenExpiresIn = DateTime.now().add(
        Duration(
          seconds: expires,
        ),
      );
      user.userExpiresIn = userExpiresIn ?? (DateTime.now().add(
        const Duration(
          days: 6,
        ),
      ));
      atualizarSessaoUser(user);
    } catch (erro) {
      rethrow;
    }
  }

  bool isRegisteredUser() {
    return GetIt.instance.isRegistered<User>();
  }
}
