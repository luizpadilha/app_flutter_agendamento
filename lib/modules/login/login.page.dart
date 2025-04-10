import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/elevated.button.component.dart';
import 'package:mybabernew/components/icon.button.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/text.form.field.component.dart';
import 'package:mybabernew/exceptions/my.exception.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/login/login.controller.dart';

class LoginPage extends StatefulWidget {
  final LoginController controller;
  final bool logout;

  const LoginPage({
    required this.controller,
    required this.logout,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  late Future _future;

  @override
  void initState() {
    super.initState();
    if (widget.logout) {
      _future = controller.zerarUsuario(true);
    } else {
      _future = controller.carregarDadosSessao();
    }
  }

  LoginController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    var heightDisp = mediaQuery.size.height - mediaQuery.padding.top;
    return ScaffoldComponent(
      isActionVoltar: false,
      titleAppBar: '',
      isAppBar: false,
      isDrawer: false,
      body: FutureBuilder(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Carregando(inverterCor: true));
          } else {
            return TripleBuilder(
                store: controller,
                builder: (ctx, triple) {
                  return triple.isLoading
                      ? const Center(child: Carregando(inverterCor: true))
                      : SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipPath(
                              clipper: WaveClipperOne(),
                              child: Container(
                                height: heightDisp * 0.35,
                                color: Theme.of(context).colorScheme.primary,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: heightDisp * 0.07),
                                      SizedBox(
                                        width: deviceSize.width * 0.35,
                                        height: heightDisp * 0.18,
                                        child: Image.asset(
                                          fit: BoxFit.fitWidth,
                                          'assets/app/icon.png',
                                        ),
                                      ),
                                      AutoSizeText(
                                        'AgendaPro',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: deviceSize.height * 0.02,
                                right: deviceSize.width * 0.10,
                                left: deviceSize.width * 0.10),
                            child:  Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: deviceSize.height * 0.08),
                                      child: AutoSizeText(
                                        "Bem-vindo!",
                                        style: textTheme.displayLarge!.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: mediaQuery.textScaler.scale(26),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: deviceSize.height * 0.02),
                                    TextFormFieldComponent(
                                      controller: controller.loginController,
                                      keyboardType: TextInputType.text,
                                      label: "Usuário",
                                    ),
                                    SizedBox(height: deviceSize.height * 0.02),
                                    TextFormFieldComponent(
                                      controller: controller.passwordController,
                                      keyboardType: TextInputType.text,
                                      label: "Senha",
                                      obscureText: !showPassword,
                                      suffixIcon: IconButtonComponent(
                                        icon: showPassword
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.remove_red_eye,
                                        onPressed: () {
                                          showPassword = !showPassword;
                                          controller.atualizarPagina();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                        height: deviceSize.height * 0.05),
                                    ElevatedButtonComponent(
                                      color: Theme.of(context).colorScheme.secondary,
                                      isRow: true,
                                      isBorderCircular: true,
                                      label: 'Entrar',
                                      onPressed: () async => await _submit(context),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    try {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) {
        controller.atualizarPagina();
        return;
      }
      await controller.buscarUser();
      Modular.to.pushReplacementNamed(HomeModule.ROUTE);
    } catch (erro) {
      if (erro is MyException) {
        AlertComponent.show(context,
            title: "Ops!", subTitle: erro.msg, style: AlertStyle.error);
      } else {
        AlertComponent.show(context,
            title: "Ops!", subTitle: "Erro", style: AlertStyle.error);
      }
    }
  }
}
