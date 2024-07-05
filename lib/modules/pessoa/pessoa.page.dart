import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/icon.button.add.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/slidable.component.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';

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
    return ScaffoldComponent(
        isActionHome: true,
        isActionVoltar: false,
        isDrawer: false,
        labelAppBar: 'Pessoas',
        widgetAppBar: Container(),
        actions: [
          IconButtonAddComponent(
              onPressed: () => Modular.to.pushNamed(
                  PessoaModule.ROUTE_PESSOAS_FORM,
                  arguments: null)),
        ],
        body: FutureBuilder(
          future: _future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Carregando(inverterCor: true));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
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
                                              margin: const EdgeInsets.only(top: 2),
                                              child: SlidableComponent(
                                                contextPai: context,
                                                keySlid: Key(pess.id.toString()),
                                                functionEditar: () => Modular.to
                                                    .pushNamed(
                                                        PessoaModule
                                                            .ROUTE_PESSOAS_FORM,
                                                        arguments: pess),
                                                object: pess,
                                                futureRemover: () =>
                                                    _remover(pess.id!),
                                                child: ListTile(
                                                  title: LabelAndFieldComponent(
                                                    label: "Nome",
                                                    field: "${pess.nome}",
                                                    inline: true,
                                                  ),
                                                  subtitle: LabelAndFieldComponent(
                                                    label: "Número",
                                                    field: pess.numero!,
                                                    inline: true,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : const EmptyList();
                          }),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<void> _remover(String id) async {
    await pessoaController.removerPessoa(id);
  }
}
