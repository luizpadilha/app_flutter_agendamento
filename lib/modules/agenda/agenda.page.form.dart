import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/auto_complete.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/agenda/agenda.controller.dart';

class AgendaFormPage extends StatefulWidget {
  final AgendaController agendaController;
  Agenda? agenda;

  @override
  State<AgendaFormPage> createState() => _AgendaFormPageState();

  AgendaFormPage({
    this.agenda,
    required this.agendaController,
    super.key,
  });
}

class _AgendaFormPageState extends State<AgendaFormPage> {
  final _precoFocus = FocusNode();
  final _descricaoFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _thermPessoa = '';
  String _thermServico = '';
  bool _validatePessoa = false;
  bool _validateServico = false;
  late Future _future;

  @override
  void dispose() {
    super.dispose();
    _precoFocus.dispose();
    _descricaoFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _future = agendaController.init();
    if (widget.agenda != null) {
      agendaController.id = widget.agenda!.id!;
      agendaController.horario = widget.agenda!.horario!;
      agendaController.servico = widget.agenda!.servico!;
      agendaController.pessoa = widget.agenda!.pessoa!;
    } else {
      agendaController.horario = DateTime.now();
      agendaController.servico = Servico();
      agendaController.pessoa = Pessoa();
      agendaController.id = '';
    }
  }

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(title: const Text('Formulário de Agenda')),
      body: FutureBuilder(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Carregando(inverterCor: true));
          } else {
            return TripleBuilder(
              store: agendaController,
              builder: (ctx, triple) {
                return triple.isLoading
                    ? const Center(child: Carregando(inverterCor: true))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.6,
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text:
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(agendaController
                                                          .horario)),
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoratorComponent(
                                            label: "Horário",
                                          ).decorator()),
                                    ),
                                    DatePickerComponent(
                                      firstDate: DateTime.now(),
                                      isForm: true,
                                      hasTime: true,
                                      onDateChanged: (newDate) {
                                        agendaController.horario = newDate;
                                        agendaController.atualizarPagina();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                AutoCompleteComponent(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    _thermPessoa = textEditingValue.text;
                                    _validatePessoa = false;
                                    agendaController.atualizarPagina();

                                    if (textEditingValue.text == '') {
                                      return const Iterable<Pessoa>.empty();
                                    }

                                    return agendaController.pessoas
                                        .where((Pessoa option) {
                                      return option
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase()
                                              .trim());
                                    });
                                  },
                                  label: 'Pessoa',
                                  hintText: 'Selecione a pessoa...',
                                  term: _thermPessoa,
                                  onSelected: (Object pessoa) {
                                    agendaController.pessoa =
                                        (pessoa as Pessoa);
                                    agendaController.atualizarPagina();
                                  },
                                  validate: _validatePessoa,
                                ),
                                const SizedBox(height: 10),
                                AutoCompleteComponent(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    _thermServico = textEditingValue.text;
                                    _validateServico = false;
                                    agendaController.atualizarPagina();

                                    if (textEditingValue.text == '') {
                                      return const Iterable<Servico>.empty();
                                    }

                                    return agendaController.servicos
                                        .where((Servico option) {
                                      return option
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase()
                                              .trim());
                                    });
                                  },
                                  label: 'Serviço',
                                  hintText: 'Selecione o serviço...',
                                  term: _thermServico,
                                  onSelected: (Object servico) {
                                    agendaController.servico =
                                        (servico as Servico);
                                    agendaController.atualizarPagina();
                                  },
                                  validate: _validateServico,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: SizedBox.expand(
                                    child: TextButton(
                                      onPressed: () {
                                        _submit(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Gravar",
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: mediaQuery.textScaler
                                                    .scale(14)),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(
                                            child: Icon(
                                              Icons.lock_open,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    _validatePessoa =
        agendaController.pessoa == null || agendaController.pessoa?.id == null;
    _validateServico = agendaController.servico == null ||
        agendaController.servico?.id == null;
    if (!isValid || _validatePessoa || _validateServico) {
      agendaController.atualizarPagina();
      return;
    }
    try {
      await agendaController.salvarAgendas();
      await agendaController.buscarAgendas();
      Modular.to.pop(context);
    } catch (erro) {
      print('Erro salvar agenda: ' + erro.toString());
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao salvar agenda",
          style: AlertStyle.error);
    }
  }
}
