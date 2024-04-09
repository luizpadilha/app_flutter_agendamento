import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
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
      appBar: AppBar(title: Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TripleBuilder<HomeController, List<Notificacao>>(
              store: controller,
              builder: (ctx, triple) {
                return triple.isLoading
                    ? const Center(child: Carregando(inverterCor: true))
                    : triple.state.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: controller.buscarAplicacoes,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
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
                                      margin: const EdgeInsets.only(top: 50),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 60, 15, 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            LabelAndField(
                                              label: "Titulo",
                                              field: "${notificacao.titulo}",
                                              inline: true,
                                            ),
                                            LabelAndField(
                                              label: "Descrição",
                                              field: "${notificacao.descricao}",
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
                                      margin: const EdgeInsets.only(top: 10),
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
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 60, 15, 15),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/empty-list.png',
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    // color: Colors.black87,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AutoSizeText(
                                    "Não foram encontrados cadastros vinculados ao seu CPF/CNPJ",
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                        fontSize: MediaQuery.of(context)
                                            .textScaler
                                            .scale(12),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          );
              }),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const BottomBarComponent(),
    );
  }
}
