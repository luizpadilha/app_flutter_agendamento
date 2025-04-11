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
import 'package:mybabernew/components/text.form.field.component.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';

class PessoaFormPage extends StatefulWidget {
  @override
  State<PessoaFormPage> createState() => _PessoaFormPageState();

  Pessoa? pessoa;
  final PessoaController pessoaController;
  bool vizualizar;

  PessoaFormPage({
    this.pessoa,
    required this.pessoaController,
    this.vizualizar = false,
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
    return ScaffoldComponent(
      isActionHome: false,
      isActionVoltar: true,
      isDrawer: false,
      titleAppBar: 'Cliente Cadastro',
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
                            TextFormFieldComponent(
                              readOnly: widget.vizualizar,
                              validar: true,
                              focusNodeAtual: _nomeFocus,
                              focusNodeProx: _numeroFocus,
                              controller: pessoaController.nomeController,
                              keyboardType: TextInputType.text,
                              label: "Nome",
                            ),
                            const SizedBox(height: 10),
                            TextFormFieldComponent(
                                readOnly: widget.vizualizar,
                                validar: true,
                                focusNodeAtual: _numeroFocus,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TelefoneInputFormatter(),
                                ],
                                controller: pessoaController.numeroController,
                                keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                                label: "Número",
                            ),
                            const SizedBox(height: 10),
                            if (!widget.vizualizar)
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
      print('Erro salvar cliente: ' + erro.toString());
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao salvar cliente",
          style: AlertStyle.error);
    }
  }
}
