import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/entity/notificacao.dart';
import 'package:mybabernew/modules/home/home.controller.dart';

import '../../components/carregando.component.dart';

class HomePage extends StatefulWidget {
  final HomeController cadastroController;

  const HomePage({required this.cadastroController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    controller.buscarAplicacoes();
  }

  HomeController get controller => widget.cadastroController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      drawer: const AppDrawerComponent(),
      body: TripleBuilder<HomeController, List<Notificacao>>(
          store: controller,
          builder: (ctx, triple) {
            return triple.isLoading
                ? const Center(child: Carregando(inverterCor: true))
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: triple.state.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: controller.buscarAplicacoes,
                            child: ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: triple.state.map((notificacao) {
                                return Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      elevation: 0,
                                      color: Colors.white,
                                      margin:
                                          const EdgeInsets.only(top: 50),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 60, 15, 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            LabelAndFieldComponent(
                                              label: "Titulo",
                                              field:
                                                  "${notificacao.titulo}",
                                              inline: true,
                                            ),
                                            LabelAndFieldComponent(
                                              label: "Descrição",
                                              field:
                                                  "${notificacao.descricao}",
                                              inline: true,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              child: Icon(
                                                FontAwesomeIcons.gear,
                                                color: Colors.white,
                                                size: 30,
                                              )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Notificação",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        : const EmptyList(),
                  );
          }),
      extendBody: true,
      bottomNavigationBar: const BottomBarComponent(),
    );
  }
}
