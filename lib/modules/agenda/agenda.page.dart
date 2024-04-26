import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker.component.dart';
import 'package:mybabernew/components/dismissible.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/modules/agenda/agenda.controller.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';

class AgendaPage extends StatefulWidget {
  final AgendaController agendaController;

  const AgendaPage({required this.agendaController});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = agendaController.buscarAgendas();
  }

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        drawer: const AppDrawerComponent(),
        bottomNavigationBar: const BottomBarComponent(),
        extendBody: true,
        appBar: AppBar(
          title: const Text('Gerenciar Agenda'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Modular.to
                    .pushNamed(AgendaModule.ROUTE_AGENDA_FORM, arguments: null);
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: deviceSize.width * 0.5,
                              child: Row(
                                children: [
                                  Text(
                                    'Data: ${DateFormat('dd/MM/yyyy').format(agendaController.dataInicial)}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(height: 2),
                                  DatePickerComponent(
                                    firstDate: DateTime(2024, 1, 1),
                                    isForm: false,
                                    hasTime: false,
                                    onDateChanged: (newDate) {
                                      setState(() {
                                        agendaController.dataInicial = newDate;
                                      });
                                      _future = agendaController.buscarAgendas();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      fit: FlexFit.loose,
                      child: TripleBuilder<AgendaController, List<Agenda>>(
                        store: agendaController,
                        builder: (ctx, triple) {
                          return triple.isLoading
                              ? const Center(
                                  child: Carregando(inverterCor: true))
                              : triple.state.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: () => _buscarAgendas(context),
                                      child: ListView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: triple.state.map((agend) {
                                          return DismissibleComponent(
                                            contextPai: context,
                                            keyDism: Key(agend.id.toString()),
                                            idRemover: agend.id!,
                                            object: agend,
                                            futureRemover: () => _remover(agend.id!),
                                            child: Card(
                                              color: Colors.white,
                                              margin: const EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                                      radius: 30,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all( 5),
                                                        child: FittedBox(
                                                          child: Text(DateFormat('HH:mm').format(agend.horario!)),
                                                        ),
                                                      ),
                                                    ),
                                                    title: LabelAndFieldComponent(
                                                      label: "Pessoa",
                                                      field: "${agend.pessoa!.nome}",
                                                      inline: true,
                                                    ),
                                                    subtitle: LabelAndFieldComponent(
                                                      label: "Serviço",
                                                      field: "${agend.servico!.descricao}",
                                                      inline: true,
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
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<void> _remover(String id) async {
    await agendaController.removerAgenda(id);
  }

  Future<void> _buscarAgendas(BuildContext context) async {
    try {
      return await agendaController.buscarAgendas();
    } catch (erro) {
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao buscar agenda",
          style: AlertStyle.error);
    }
  }
}
