import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/text_button.component.dart';
import 'package:mybabernew/modules/config/config.controller.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.module.dart';

class ConfigPage extends StatefulWidget {
  final ConfigController configController;

  ConfigPage({required this.configController});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  late Future _future;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
      _future = configController.buscarConfiguracao();
  }

  ConfigController get configController => widget.configController;

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      isActionHome: true,
      isActionVoltar: false,
      isDrawer: false,
      labelAppBar: 'Configurações',
      widgetAppBar: Container(),
      body: FutureBuilder(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Carregando(inverterCor: true));
          } else {
            return TripleBuilder(
                store: configController,
                builder: (ctx, triple) {
                  return triple.isLoading
                      ? const Center(child: Carregando(inverterCor: true))
                      : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextButtonComponent(
                              label: 'Expediente',
                              icon: Icons.alarm_rounded,
                                    onPressed: () => Modular.to.pushNamed(
                                        '${ConfigExpedienteModule.ROUTE}/?idConfig=${configController.getIdConfig()}'),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
