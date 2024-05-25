import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/box_text_button.component.dart';
import 'package:mybabernew/components/drop_down.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/components/time_picker.component.dart';
import 'package:mybabernew/entity/config_expediente.dart';
import 'package:mybabernew/enums/dia_semana.dart';
import 'package:mybabernew/modules/configexpediente/config.expediente.controller.dart';

class ConfigExpedienteFormPage extends StatefulWidget {
  @override
  State<ConfigExpedienteFormPage> createState() => _ConfigExpedienteFormPageState();

  ConfigExpediente? configExped;
  final String idConfig;
  final ConfigExpedienteController configExpedienteController;

  ConfigExpedienteFormPage({
    this.configExped,
    required this.idConfig,
    required this.configExpedienteController,
    super.key,
  });
}

class _ConfigExpedienteFormPageState extends State<ConfigExpedienteFormPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if (widget.configExped != null) {
      configExpedienteController.inicioExpediente = widget.configExped!.inicioExpediente!;
      configExpedienteController.inicioAlmoco = widget.configExped!.inicioAlmoco!;
      configExpedienteController.finalAlmoco = widget.configExped!.finalAlmoco!;
      configExpedienteController.finalExpediente = widget.configExped!.finalExpediente!;
      configExpedienteController.id = widget.configExped!.id!;
      configExpedienteController.diaSemana = widget.configExped!.diaSemana;
    } else {
      configExpedienteController.inicioExpediente = const TimeOfDay(hour: 08, minute: 0);
      configExpedienteController.inicioAlmoco = const TimeOfDay(hour: 12, minute: 0);
      configExpedienteController.finalAlmoco = const TimeOfDay(hour: 13, minute: 0);
      configExpedienteController.finalExpediente = const TimeOfDay(hour: 19, minute: 0);
      configExpedienteController.id = '';
      configExpedienteController.diaSemana = DiaSemana.SEGUNDA;
    }
    configExpedienteController.idConfig = widget.idConfig;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  ConfigExpedienteController get configExpedienteController => widget.configExpedienteController;


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(title: const Text('Formulário de Expediente')),
      body: TripleBuilder(
          store: configExpedienteController,
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
                                      initialValue: configExpedienteController.diaSemana!.descricao,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoratorComponent(
                                        label: "Dia da Semana",
                                      ).decorator()),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: mediaQuery.size.width * 0.6,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: configExpedienteController.inicioExpediente!.format(context)),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoratorComponent(
                                      label: "Inicio Expediente",
                                    ).decorator(),
                                    validator: (_value) {
                                      final valueString = _value ?? '';
                                      List<String> partes = valueString.split(':');
                                      int hora = int.parse(partes[0]);
                                      int minuto = int.parse(partes[1]);
                                      if (hora == 0 && minuto == 0) {
                                        return 'O campo deve ser informado';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                TimePickerComponent(
                                  helpText: 'Selecione o Inicio Expediente',
                                  onTimeChanged: (newTime) {
                                    configExpedienteController.inicioExpediente = newTime;
                                    configExpedienteController.atualizarPagina();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: mediaQuery.size.width * 0.6,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: configExpedienteController.inicioAlmoco!.format(context)),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoratorComponent(
                                      label: "Inicio Almoço",
                                    ).decorator(),
                                    validator: (_value) {
                                      final valueString = _value ?? '';
                                      List<String> partes = valueString.split(':');
                                      int hora = int.parse(partes[0]);
                                      int minuto = int.parse(partes[1]);
                                      if (hora == 0 && minuto == 0) {
                                        return 'O campo deve ser informado';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                TimePickerComponent(
                                  helpText: 'Selecione o Inicio Almoço',
                                  onTimeChanged: (newTime) {
                                    configExpedienteController.inicioAlmoco = newTime;
                                    configExpedienteController.atualizarPagina();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: mediaQuery.size.width * 0.6,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: configExpedienteController.finalAlmoco!.format(context)),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoratorComponent(
                                      label: "Final Almoço",
                                    ).decorator(),
                                    validator: (_value) {
                                      final valueString = _value ?? '';
                                      List<String> partes = valueString.split(':');
                                      int hora = int.parse(partes[0]);
                                      int minuto = int.parse(partes[1]);
                                      if (hora == 0 && minuto == 0) {
                                        return 'O campo deve ser informado';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                TimePickerComponent(
                                  helpText: 'Selecione o Final Almoço',
                                  onTimeChanged: (newTime) {
                                    configExpedienteController.finalAlmoco = newTime;
                                    configExpedienteController.atualizarPagina();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: mediaQuery.size.width * 0.6,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: configExpedienteController.finalExpediente!.format(context)),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoratorComponent(
                                      label: "Final Expediente",
                                    ).decorator(),
                                    validator: (_value) {
                                      final valueString = _value ?? '';
                                      List<String> partes = valueString.split(':');
                                      int hora = int.parse(partes[0]);
                                      int minuto = int.parse(partes[1]);
                                      if (hora == 0 && minuto == 0) {
                                        return 'O campo deve ser informado';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                TimePickerComponent(
                                  helpText: 'Selecione o Final Expediente',
                                  onTimeChanged: (newTime) {
                                    configExpedienteController.finalExpediente = newTime;
                                    configExpedienteController.atualizarPagina();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            BoxTextButtonComponenet(
                              label: 'Gravar',
                              icon: Icons.save,
                              onPressed: () => _submit(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    try {
      await configExpedienteController.salvarConfiguracoes();
      await configExpedienteController.buscarConfiguracoes(widget.idConfig);
      Modular.to.pop(context);
    } catch (erro) {
      print('Erro salvar config exped: ' + erro.toString());
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao salvar configuração expediente",
          style: AlertStyle.error);
    }
  }
}
