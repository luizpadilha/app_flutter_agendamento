import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class PessoaPage extends StatefulWidget {
  final PessoaController pessoaController;

  PessoaPage({required this.pessoaController});

  @override
  State<PessoaPage> createState() => _PessoaPageState();
}

class _PessoaPageState extends State<PessoaPage> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = pessoaController.buscarPessoas();
  }

  PessoaController get pessoaController => widget.pessoaController;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return Scaffold(
        bottomNavigationBar: const BottomBarComponent(),
        extendBody: true,
        appBar: AppBar(
          title: Text('Gerenciar Pessoas'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Modular.to.pushNamed(PessoaModule.ROUTE_PESSOAS_FORM,
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
                  child: TripleBuilder<PessoaController, List<Pessoa>>(
                      store: pessoaController,
                      builder: (ctx, triple) {
                        return triple.isLoading
                            ? const Center(child: Carregando(inverterCor: true))
                            : triple.state.isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: pessoaController.buscarPessoas,
                                    child: ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: triple.state.map((pess) {
                                        return Card(
                                          color: Colors.white,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.70,
                                                  child: Column(
                                                    children: [
                                                      LabelAndFieldComponent(
                                                        label: "Nome",
                                                        field: "${pess.nome}",
                                                        inline: true,
                                                      ),
                                                      LabelAndFieldComponent(
                                                        label: "Número",
                                                        field: pess.numero!,
                                                        inline: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Modular.to.pushNamed(
                                                              PessoaModule
                                                                  .ROUTE_PESSOAS_FORM,
                                                              arguments: pess);
                                                        },
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        icon: Icon(Icons.edit),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog<bool>(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                              title: const Text(
                                                                  'Tem Certeza?'),
                                                              content: const Text(
                                                                  'Quer remover a Pessoa?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop(
                                                                              false),
                                                                  child:
                                                                      const Text(
                                                                          'Não'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop(
                                                                              true),
                                                                  child:
                                                                      const Text(
                                                                          'Sim'),
                                                                ),
                                                              ],
                                                            ),
                                                          ).then((value) async {
                                                            if (value ??
                                                                false) {
                                                              try {
                                                                await pessoaController
                                                                    .removerPessoa(
                                                                        pess.id!);
                                                              } catch (error) {
                                                                msg.showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        error
                                                                            .toString()),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          });
                                                        },
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                        icon: const Icon(
                                                            Icons.delete),
                                                      ),
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
