import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/dismissible.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class ServicoPage extends StatefulWidget {
  final ServicoController servicoController;

  const ServicoPage({required this.servicoController});

  @override
  State<ServicoPage> createState() => _ServicoPageState();
}

class _ServicoPageState extends State<ServicoPage> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = servicoController.buscarServicos();
  }

  ServicoController get servicoController => widget.servicoController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawerComponent(),
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(
        title: Text('Gerenciar Serviços'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Modular.to.pushNamed(ServicoModule.ROUTE_SERVICOS_FORM,
                  arguments: null);
            },
          ),
        ],
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
                    child: TripleBuilder<ServicoController, List<Servico>>(
                        store: servicoController,
                        builder: (ctx, triple) {
                          return triple.isLoading
                              ? const Center(child: Carregando(inverterCor: true))
                              : triple.state.isNotEmpty
                              ? RefreshIndicator(
                            onRefresh: servicoController.buscarServicos,
                            child: ListView(
                              physics:
                              const AlwaysScrollableScrollPhysics(),
                              children: triple.state.map((serv) {
                                return DismissibleComponent(
                                  contextPai: context,
                                  keyDism: Key(serv.id.toString()),
                                  idRemover: serv.id!,
                                  object: serv,
                                  futureRemover: () => _remover(serv.id!),
                                  child: Card(
                                    color: Colors.white,
                                    margin:
                                    const EdgeInsets.only(top: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                            MediaQuery.of(context).size.width * 0.70,
                                            child: Column(
                                              children: [
                                                LabelAndFieldComponent(
                                                  label: "Descrição",
                                                  field: "${serv.descricao}",
                                                  inline: true,
                                                ),
                                                LabelAndFieldComponent(
                                                  label: "Preço",
                                                  field: UtilBrasilFields.obterReal(serv.preco!),
                                                  inline: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Modular.to.pushNamed(ServicoModule.ROUTE_SERVICOS_FORM,
                                                        arguments: serv);
                                                  },
                                                  color: Theme.of(context).colorScheme.primary,
                                                  icon: const Icon(Icons.edit),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),)
                              : const EmptyList();
                        }),
                  ),
                );
              }
          }
      ),
    );
  }

  Future<void> _remover(String id) async {
    await servicoController.removerServico(id);
  }
}
