import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/entity/config_expediente.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.controller.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.module.dart';

class ConfigExpedientePage extends StatefulWidget {

  final ConfigExpedienteController configExpedienteController;
  final String configId;

  ConfigExpedientePage({required this.configExpedienteController, required this.configId});

  @override
  State<ConfigExpedientePage> createState() => _ConfigExpedientePageState();
}

class _ConfigExpedientePageState extends State<ConfigExpedientePage> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = configExpedienteController.buscarConfiguracoes(widget.configId);
  }

  ConfigExpedienteController get configExpedienteController => widget.configExpedienteController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomBarComponent(),
        extendBody: true,
        appBar: AppBar(
          title: Text('Configurar Expediente'),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Carregando(inverterCor: true));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TripleBuilder<ConfigExpedienteController, List<ConfigExpediente>>(
                      store: configExpedienteController,
                      builder: (ctx, triple) {
                        return triple.isLoading
                            ? const Center(child: Carregando(inverterCor: true))
                            : triple.state.isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: () => configExpedienteController.buscarConfiguracoes(widget.configId),
                                    child: ListView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: triple.state.map((config) {
                                        return Card(
                                          color: Colors.white,
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.70,
                                                  child: Column(
                                                    children: [
                                                      LabelAndFieldComponent(
                                                        label: "Expediente",
                                                        field: "${config.inicioExpediente!.format(context)} à ${config.finalExpediente!.format(context)}",
                                                        inline: true,
                                                      ),
                                                      LabelAndFieldComponent(
                                                        label: "Almoço",
                                                        field: "${config.inicioAlmoco!.format(context)} à ${config.finalAlmoco!.format(context)}",
                                                        inline: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.10,
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Modular.to.pushNamed(
                                                              '${ConfigExpedienteModule.ROUTE_CONFIG_EXPD_FORM}?idConfig=${widget.configId}',
                                                              arguments: config);
                                                        },
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        icon: Icon(Icons.edit),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : const EmptyList();
                      }),
                ),
              );
            }
          },
        ));
  }

}
