import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/auto_complete.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/agenda/agenda.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class AgendaFormPage extends StatefulWidget {
  final AgendaController agendaController;
  final ServicoController servicoController;
  final PessoaController pessoaController;
  Agenda? agenda;

  @override
  State<AgendaFormPage> createState() => _AgendaFormPageState();

  AgendaFormPage({
    this.agenda,
    required this.agendaController,
    required this.servicoController,
    required this.pessoaController,
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
  List<Servico> servicos = [];
  List<Pessoa> pessoas = [];
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

  @override
  void initState() {
    super.initState();
    _future = _buscarDados();
  }

  Future<void> _buscarDados() async {
    await servicoController.buscarServicos();
    await pessoaController.buscarPessoas();
    servicos = servicoController.state;
    pessoas = pessoaController.state;
    print('totalPEs: ${pessoaController.state.length}');
    print('totalSErv: ${servicoController.state.length}');
  }

  ServicoController get servicoController => widget.servicoController;

  PessoaController get pessoaController => widget.pessoaController;

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: _future,
      builder: (_, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return const Center(
            child: Carregando(inverterCor: true),
          );
        } else {
          return Scaffold(
              bottomNavigationBar: const BottomBarComponent(),
              extendBody: true,
              appBar: AppBar(title: const Text('Formulário de Agenda')),
              body: TripleBuilder(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(height: 10),
                                  DatePickerComponent(
                                    onDateChanged: (newDate) {
                                      agendaController.horario = newDate;
                                      agendaController.atualizarPagina();
                                    },
                                    selectedDate: agendaController.horario,
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

                                      return pessoas.where((Pessoa option) {
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
                                      print('selecionei');
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

                                      return servicos.where((Servico option) {
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
                                                  fontSize: mediaQuery
                                                      .textScaler
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
              ));
        }
      },
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
