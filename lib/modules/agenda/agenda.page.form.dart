import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/auto_complete.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/box_text_button.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/date_picker.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/components/time_picker.component.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/horarios.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/agenda/agenda.controller.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';

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
  FocusNode _pessoaFocus = FocusNode();
  FocusNode _servicoFocus = FocusNode();
  FocusNode _dataFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _thermPessoa = '';
  String _thermServico = '';
  bool _validatePessoa = false;
  bool _validateServico = false;
  bool _validateHorario = false;
  late Future _future;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _future = agendaController.initForm();
    if (widget.agenda != null) {
      agendaController.id = widget.agenda!.id!;
      agendaController.horario = widget.agenda!.horario!;
      agendaController.servico = widget.agenda!.servico!;
      agendaController.pessoa = widget.agenda!.pessoa!;
    } else {
      agendaController.data = DateTime.now();
      agendaController.horario = null;
      agendaController.servico = null;
      agendaController.pessoa = null;
      agendaController.horarios = [];
      agendaController.id = '';
    }
  }

  AgendaController get agendaController => widget.agendaController;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: false,
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
                                    Expanded(
                                      child: AutoCompleteComponent(
                                        initialValue: agendaController.pessoa?.toString(),
                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                          _thermPessoa = textEditingValue.text;
                                          _validatePessoa = false;
                                          agendaController.atualizarPagina();

                                          if (textEditingValue.text == '') {
                                            return const Iterable<Pessoa>.empty();
                                          }

                                          return agendaController.pessoas.where((Pessoa option) {
                                            return option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase().trim());
                                          });
                                        },
                                        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                          _pessoaFocus = focusNode;
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            style: textTheme.bodyMedium,
                                            onEditingComplete: onEditingComplete,
                                            decoration: InputDecoratorComponent(
                                              label: 'Pessoa',
                                              hintText: 'Selecione a pessoa...',
                                              errorText: _validatePessoa ? "O campo deve ser informado" : null,
                                              prefixIcon: const Icon(Icons.search),
                                            ).decorator(),
                                          );
                                        },
                                        term: _thermPessoa,
                                        onSelected: (Object pessoa) {
                                          agendaController.pessoa = (pessoa as Pessoa);
                                          agendaController.atualizarPagina();
                                          FocusScope.of(context).requestFocus(_servicoFocus);
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      color: Theme.of(context).colorScheme.primary,
                                      icon: const Icon(Icons.person_add_outlined),
                                      onPressed: () {
                                        Modular.to.pushNamed(PessoaModule.ROUTE_PESSOAS_FORM, arguments: null).then((value) => agendaController.atualizarPessoas());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                AutoCompleteComponent(
                                  initialValue: agendaController.servico?.toString(),
                                  optionsBuilder: (TextEditingValue textEditingValue) {
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
                                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                    _servicoFocus = focusNode;
                                    return TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: textTheme.bodyMedium,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoratorComponent(
                                        label: 'Serviço',
                                        hintText: 'Selecione a serviço...',
                                        errorText: _validateServico ? "O campo deve ser informado" : null,
                                        prefixIcon: const Icon(Icons.search),
                                      ).decorator(),
                                    );
                                  },
                                  term: _thermServico,
                                  onSelected: (Object servico) {
                                    agendaController.servico = (servico as Servico);
                                    agendaController.buscarHorarios().then((value) {
                                      agendaController.horario = null;
                                      agendaController.atualizarPagina();
                                      FocusScope.of(context).requestFocus(_dataFocus);
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.6,
                                      child: TextFormField(
                                        focusNode: _dataFocus,
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: DateFormat('dd/MM/yyyy')
                                                  .format(
                                                      agendaController.data)),
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoratorComponent(
                                            label: "Data",
                                          ).decorator()),
                                    ),
                                    DatePickerComponent(
                                      firstDate: DateTime.now(),
                                      isForm: true,
                                      hasTime: false,
                                      onDateChanged: (newDate) {
                                        agendaController.data = newDate;
                                        agendaController.horario = null;
                                        _validateHorario = false;
                                        agendaController.buscarHorarios().then((value) => agendaController.atualizarPagina());
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          border: _validateHorario ? Border.all(color: Colors.red, width: 1) : null,
                                          color: Colors.green[100]!,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Horário: ${agendaController.horario == null ? 'Nenhum' : DateFormat('dd/MM/yyyy HH:mm').format(agendaController.horario!)}',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                    ),
                                    TimePickerComponent(
                                      helpText: "Selecione o Horário",
                                      onTimeChanged: (newTime) {
                                        _validateHorario = false;
                                        agendaController.atribuirHorario(Horarios(horario: '${newTime.hour}:${newTime.minute}'));
                                        agendaController.atualizarPagina();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: agendaController.horarios.isNotEmpty,
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(10.0),
                                          itemCount: agendaController.horarios.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: GridTile(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _validateHorario = false;
                                                        agendaController.atribuirHorario(agendaController.horarios[index]);
                                                        agendaController.atualizarPagina();
                                                      },
                                                      child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: agendaController.isHorarioSelecionado(agendaController.horarios[index])
                                                            ? Colors.greenAccent
                                                            : Colors.white,
                                                            width: 3),
                                                        gradient: LinearGradient(
                                                          colors: [Theme.of(context).colorScheme.primary, Colors.grey],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                      ),
                                                    child: Center(
                                                      child: Text(
                                                        agendaController.horarios[index].horario!,
                                                        style: textTheme.bodyMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                BoxTextButtonComponenet(
                                  label: 'Gravar',
                                  icon: Icons.save,
                                  onPressed: () => _submit(context),
                                ),
                                const SizedBox(height: 10),
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
    _validatePessoa =  agendaController.pessoa == null || agendaController.pessoa?.id == null;
    _validateServico = agendaController.servico == null || agendaController.servico?.id == null;
    _validateHorario = agendaController.horario == null;
    if (!isValid || _validatePessoa || _validateServico || _validateHorario) {
      agendaController.atualizarPagina();
      return;
    }
    try {
      await agendaController.salvarAgendas();
      await agendaController.buscarAgendas();
      agendaController.pessoa = null;
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
