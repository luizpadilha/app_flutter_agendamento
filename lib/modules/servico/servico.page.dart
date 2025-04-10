import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/icon.button.add.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/slidable.component.dart';
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
    return ScaffoldComponent(
      isActionHome: true,
      isActionVoltar: false,
      isDrawer: false,
      titleAppBar: 'Serviços',
      actions: [
        IconButtonAddComponent(
            onPressed: () => Modular.to.pushNamed(
                ServicoModule.ROUTE_SERVICOS_FORM,
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
                      child: TripleBuilder<ServicoController, List<Servico>>(
                          store: servicoController,
                          builder: (ctx, triple) {
                            return triple.isLoading
                                ? const Center(child: Carregando(inverterCor: true))
                                : triple.state.isNotEmpty
                                    ? RefreshIndicator (
                                        onRefresh: servicoController.buscarServicos,
                                        child: ListView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          children: triple.state.map((serv) {
                                            return Card(
                                              color: Colors.white,
                                              margin: const EdgeInsets.only(top: 2),
                                              child: SlidableComponent(
                                                contextPai: context,
                                                functionEditar: () => Modular.to.pushNamed(ServicoModule.ROUTE_SERVICOS_FORM, arguments: serv),
                                                keySlid: Key(serv.id.toString()),
                                                object: serv,
                                                futureRemover: () => _remover(serv.id!),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Modular.to.pushNamed(ServicoModule.ROUTE_SERVICOS_FORM_EXIBE, arguments: serv);
                                                  },
                                                  child: ListTile(
                                                    trailing: CircleAvatar(
                                                      radius: 40,
                                                      backgroundColor: Colors.grey[200],
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.grey[300],
                                                        backgroundImage: serv.image != null ? FileImage(serv.image!) : null,
                                                      ),
                                                    ),
                                                    title: LabelAndFieldComponent(
                                                      label: "Descrição",
                                                      field: "${serv.descricao}",
                                                      inline: true,
                                                    ),
                                                    subtitle: LabelAndFieldComponent(
                                                      label: "Preço",
                                                      field: UtilBrasilFields.obterReal(serv.preco),
                                                      inline: true,
                                                    ),
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
          }),
    );
  }

  Future<void> _remover(String id) async {
    await servicoController.removerServico(id);
  }
}
