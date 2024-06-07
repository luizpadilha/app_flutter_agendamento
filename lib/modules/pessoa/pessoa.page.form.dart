import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/elevated.button.component.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';

class PessoaFormPage extends StatefulWidget {
  @override
  State<PessoaFormPage> createState() => _PessoaFormPageState();

  Pessoa? pessoa;
  final PessoaController pessoaController;

  PessoaFormPage({
    this.pessoa,
    required this.pessoaController,
    super.key,
  });
}

class _PessoaFormPageState extends State<PessoaFormPage> {
  final _numeroFocus = FocusNode();
  final _nomeFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _numeroFocus.dispose();
    _nomeFocus.dispose();
  }


  @override
  void initState() {
    super.initState();
    if (widget.pessoa != null) {
      pessoaController.nomeController.text = widget.pessoa!.nome!;
      pessoaController.numeroController.text = widget.pessoa!.numero!;
      pessoaController.id = widget.pessoa!.id!;
    } else {
      pessoaController.nomeController.text = '';
      pessoaController.numeroController.text = '44';
      pessoaController.id = '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  PessoaController get pessoaController => widget.pessoaController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBarComponent(),
      extendBody: true,
      appBar: AppBar(title: Text('Formulário de Pessoa')),
      body: TripleBuilder(
          store: pessoaController,
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
                                      .requestFocus(_numeroFocus);
                                },
                                focusNode: _nomeFocus,
                                controller: pessoaController.nomeController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoratorComponent(
                                  label: "Nome",
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
                                focusNode: _numeroFocus,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TelefoneInputFormatter(),
                                ],
                                controller: pessoaController.numeroController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoratorComponent(
                                  label: "Número",
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
      pessoaController.id = await pessoaController.salvarPessoas();
      await pessoaController.buscarPessoas();
      Modular.to.pop(pessoaController.id);
    } catch (erro) {
      print('Erro salvar pessoa: ' + erro.toString());
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao salvar pessoa",
          style: AlertStyle.error);
    }
  }
}
