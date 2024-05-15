import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/box_text_button.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
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
    print('teste1');
    super.initState();
    print('teste');
    if (widget.logout) {
      _future = controller.zerarUsuario(true);
    } else {
      _future = controller.carregarDadosSessao();
    }
  }

  LoginController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  TextFormField(
                                      validator: (_value) {
                                        final valueString = _value ?? '';
                                        if (valueString.trim().isEmpty) {
                                          return 'O campo deve ser informado';
                                        }
                                        return null;
                                      },
                                      controller: controller.loginController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoratorComponent(
                                        label: "Login",
                                      ).decorator()),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    validator: (_value) {
                                      final valueString = _value ?? '';
                                      if (valueString.trim().isEmpty) {
                                        return 'O campo deve ser informado';
                                      }
                                      return null;
                                    },
                                    controller: controller.passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: !showPassword,
                                    decoration: InputDecoratorComponent(
                                      label: "Senha",
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showPassword
                                              ? Icons.remove_red_eye_outlined
                                              : Icons.remove_red_eye,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          showPassword = !showPassword;
                                          controller.atualizarPagina();
                                        },
                                      ),
                                    ).decorator(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BoxTextButtonComponenet(
                                    label: 'Acessar',
                                    icon: Icons.lock_open,
                                    onPressed: () => _submit(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                });
          }
        },
      ),
      extendBody: true,
    );
  }

  Future<void> _submit(BuildContext context) async {
    try {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) {
        return;
      }
      User? user = await controller.buscarUser();
      if (user != null) {
        AlertComponent.show(context,
            title: "Olá ${user.username}",
            subTitle: "Seja bem vindo", onConfirm: () {
              Modular.to.pushReplacementNamed(HomeModule.ROUTE);
            });
      }
    } catch (erro) {
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: erro.toString(),
          style: AlertStyle.error);
    }
  }
}
