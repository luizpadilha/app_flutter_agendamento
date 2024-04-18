import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
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
    } else {
      servicoController.precoController.text = '';
      servicoController.descricaoController.text = '';
      servicoController.id = '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(title: Text('Formulário de Servico')),
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
                                  onPressed: () => _submit(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Gravar",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
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
          }),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    try {
      await servicoController.salvarServicos();
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
