import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
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
  @override
  void initState() {
    super.initState();
  }

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    _buscarAgendas(context);
    final msg = ScaffoldMessenger.of(context);
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(
        title: Text('Gerenciar Agenda'),
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
      body: Padding(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text('Data Inicial: '),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(agendaController.dataInicial),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Data Final: '),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(agendaController.dataInicial),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
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
                      ? const Center(child: Carregando(inverterCor: true))
                      : triple.state.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () => _buscarAgendas(context),
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: triple.state.map((agend) {
                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            radius: 30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: FittedBox(
                                                child: Text(DateFormat('HH:mm')
                                                    .format(agend.horario!)),
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
                                            field:
                                                "${agend.servico!.descricao}",
                                            inline: true,
                                          ),
                                          trailing: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog<bool>(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Tem Certeza?'),
                                                      content: const Text(
                                                          'Quer remover o item da Agenda?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(ctx)
                                                                  .pop(false),
                                                          child:
                                                              const Text('Não'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(ctx)
                                                                  .pop(true),
                                                          child:
                                                              const Text('Sim'),
                                                        ),
                                                      ],
                                                    ),
                                                  ).then((value) async {
                                                    if (value ?? false) {
                                                      try {
                                                        await agendaController
                                                            .removerAgenda(
                                                                agend.id!);
                                                      } catch (error) {
                                                        msg.showSnackBar(
                                                          SnackBar(
                                                            content: Text(error
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
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
      ),
    );
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
