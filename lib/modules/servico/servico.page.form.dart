import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/elevated.button.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/components/time_picker.component.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';

class ServicoFormPage extends StatefulWidget {
  @override
  State<ServicoFormPage> createState() => _ServicoFormPageState();

  Servico ?servico;

  ServicoFormPage({this.servico, super.key});
}

class _ServicoFormPageState extends State<ServicoFormPage> {
  final ServicoController servicoController = Modular.get();
  final _precoFocus = FocusNode();
  final _descricaoFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _precoFocus.dispose();
    _descricaoFocus.dispose();
  }


  @override
  void initState() {
    super.initState();
    if (widget.servico != null) {
      servicoController.precoController.text = UtilBrasilFields.obterReal(widget.servico!.preco!);
      servicoController.descricaoController.text = widget.servico!.descricao!;
      servicoController.id = widget.servico!.id!;
      servicoController.tempo = widget.servico!.tempo!;
    } else {
      servicoController.precoController.text = '';
      servicoController.descricaoController.text = '';
      servicoController.id = '';
      servicoController.tempo = const TimeOfDay(minute: 0, hour: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ScaffoldComponent(
      isActionHome: false,
      isActionVoltar: true,
      isDrawer: false,
      labelAppBar: 'Serviço Cadastro',
      widgetAppBar: Container(),
      body: TripleBuilder(
          store: servicoController,
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
                                    controller: TextEditingController(text: servicoController.tempo.format(context)),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoratorComponent(
                                      label: "Tempo",
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
                                  helpText: 'Selecione o Tempo',
                                  onTimeChanged: (newTime) {
                                    servicoController.tempo = newTime;
                                    servicoController.atualizarPagina();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                                validator: (_value) {
                                  final valueString = _value ?? '';
                                  if (valueString.trim().isEmpty) {
                                    return 'O campo deve ser informado';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_precoFocus);
                                },
                                focusNode: _descricaoFocus,
                                controller:
                                    servicoController.descricaoController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoratorComponent(
                                  label: "Descrição",
                                ).decorator()),
                            const SizedBox(height: 10),
                            TextFormField(
                                validator: (_value) {
                                  final valueString = _value ?? '';
                                  if (valueString.trim().isEmpty) {
                                    return 'O campo deve ser informado';
                                  }
                                  return null;
                                },
                                focusNode: _precoFocus,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(
                                      moeda: true, casasDecimais: 2),
                                ],
                                controller: servicoController.precoController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoratorComponent(
                                  label: "Preço",
                                ).decorator()),
                            const SizedBox(height: 10),
                            ElevatedButtonComponent(
                              color: Theme.of(context).colorScheme.primary,
                              isRow: true,
                              isBorderCircular: true,
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
      await servicoController.salvarServicos(context);
      await servicoController.buscarServicos();
      Modular.to.pop(context);
    } catch (erro) {
      print('Erro salvar serviço: ' + erro.toString());
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao salvar serviço",
          style: AlertStyle.error);
    }
  }
}
