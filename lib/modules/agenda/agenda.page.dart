import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/auto_complete.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker.component.dart';
import 'package:mybabernew/components/drop_down.component.dart';
import 'package:mybabernew/components/empty_list.component.dart';
import 'package:mybabernew/components/icon.button.add.component.dart';
import 'package:mybabernew/components/label_field.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/slidable.component.dart';
import 'package:mybabernew/components/whatsapp_button.component.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/enums/tipo.filtro.agenda.dart';
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
  String _thermPessoa = '';
  final FocusNode _pessoaFocus = FocusNode();
  final pessoaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = agendaController.init();
    pessoaController.text = '';
  }


  @override
  void dispose() {
    _pessoaFocus.dispose();
    super.dispose();
  }

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    return ScaffoldComponent(
        isActionHome: true,
        isActionVoltar: false,
        isDrawer: false,
        labelAppBar: 'Agenda',
        widgetAppBar: Container(),
        actions: [
          IconButtonAddComponent(
              onPressed: () => Modular.to.pushNamed(
                  AgendaModule.ROUTE_AGENDA_FORM,
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
                      child: TripleBuilder<AgendaController, List<Agenda>>(
                        store: agendaController,
                        builder: (ctx, triple) {
                          return triple.isLoading
                              ? const Center(child: Carregando(inverterCor: true))
                              : Column(
                                  children: [
                                    SizedBox(height: deviceSize.height * 0.02),
                                    Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: AnimatedContainer(
                                          height: agendaController.tipoFiltroAgenda != null ? deviceSize.height * 0.20 : deviceSize.height * 0.10,
                                          alignment: Alignment.center,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.fastOutSlowIn,
                                          child: ListView(
                                            physics: const NeverScrollableScrollPhysics(),
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text('Data: ${DateFormat('dd/MM/yyyy').format(agendaController.dataInicial)}',
                                                    style: textTheme.bodySmall,
                                                  ),
                                                  DatePickerComponent(
                                                    initialDate: agendaController.dataInicial,
                                                    firstDate: DateTime(2024, 1, 1),
                                                    isForm: false,
                                                    hasTime: false,
                                                    onDateChanged: (newDate) async {
                                                      agendaController.dataInicial = newDate;
                                                      await agendaController.buscarAgendas();
                                                      agendaController.atualizarPagina();

                                                    },
                                                  ),
                                                  SizedBox(width: deviceSize.width * 0.02),
                                                  Expanded(
                                                    flex: 3,
                                                    child: DropDownComponent(
                                                      itemVazio: true,
                                                      menuMaxHeight: deviceSize.height * 0.4,
                                                      value: agendaController.tipoFiltroAgenda,
                                                      items: TipoFiltroAgenda.values,
                                                      label: 'Filtro',
                                                      onChanged: (Object? tipo) async {
                                                          if (tipo != null) {
                                                            agendaController.tipoFiltroAgenda = tipo as TipoFiltroAgenda;
                                                          } else {
                                                            agendaController.tipoFiltroAgenda = null;
                                                            //delay por causa do AnimatedContainer
                                                            await Future.delayed(const Duration(seconds: 1), () async {
                                                              agendaController.buscarAgendas();
                                                            });
                                                          }
                                                          pessoaController.text = '';
                                                          agendaController.pessoa = null;
                                                          agendaController.atualizarPagina();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: TipoFiltroAgenda.PESSOA == agendaController.tipoFiltroAgenda,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: deviceSize.height * 0.02),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: AutoCompleteComponent(
                                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                                            _thermPessoa = textEditingValue.text;
                                                            agendaController.atualizarPagina();

                                                            if (textEditingValue.text == '') {
                                                              return const Iterable<Pessoa>.empty();
                                                            }

                                                            return agendaController.pessoas.where((Pessoa option) {
                                                              return option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase().trim());
                                                            });
                                                          },
                                                          label: 'Pessoa',
                                                          textEditingController: pessoaController,
                                                          term: _thermPessoa,
                                                          focusNode: _pessoaFocus,
                                                          onSelected: (Object pessoa) async {
                                                            agendaController.pessoa = (pessoa as Pessoa);
                                                            await agendaController.buscarAgendasByPessoa();
                                                            agendaController.atualizarPagina();
                                                            _pessoaFocus.unfocus();
                                                          },
                                                        ),
                                                      ),
                                                      IconButton(
                                                        color: Theme.of(context).colorScheme.primary,
                                                        icon: const Icon(Icons.delete),
                                                        onPressed: () async {
                                                          agendaController.pessoa = null;
                                                          pessoaController.text = '';
                                                          await agendaController.buscarAgendas();
                                                          agendaController.atualizarPagina();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: deviceSize.height * 0.02),
                                    triple.state.isNotEmpty
                                        ? Expanded(
                                          child: RefreshIndicator(
                                              onRefresh: () => _buscarAgendas(context),
                                              child: ListView(
                                                physics: const AlwaysScrollableScrollPhysics(),
                                                children: triple.state.map((agend) {
                                                  return Card(
                                                    color: Colors.white,
                                                    margin: const EdgeInsets.only(top: 2),
                                                    child: SlidableComponent(
                                                      contextPai: context,
                                                      keySlid: Key(agend.id.toString()),
                                                      object: agend,
                                                      futureRemover: () => _remover(agend.id!),
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                                          radius: 30,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5),
                                                            child: FittedBox(
                                                              child: Column(
                                                                children: [
                                                                  if (agendaController.pessoa != null)
                                                                    AutoSizeText(
                                                                      DateFormat('d/MMM').format(agend.horario!).toString(),
                                                                      style: textTheme.labelSmall,
                                                                    ),
                                                                  AutoSizeText(
                                                                      DateFormat('HH:mm').format(agend.horario!).toString(),
                                                                      style: textTheme.labelSmall
                                                                  ),
                                                                ],
                                                              ),
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
                                                        trailing: WhatsAppButton(phoneNumber: UtilBrasilFields.obterTelefone(agend.pessoa!.numero!, mascara: false),
                                                          mensagem: 'Olá ${agend.pessoa!.nome}, aviso de compromisso.\n'
                                                              '🕑 ${DateFormat('dd/MM').format(agend.horario!)} às ${DateFormat('HH:mm').format(agend.horario!)}h.\n',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                        )
                                        : const Expanded(child: SingleChildScrollView(child: EmptyList())),
                                  ],
                                );
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
