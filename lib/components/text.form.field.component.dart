import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/constants.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool validar;
  final bool readOnly;
  final bool autofocus;
  final bool isTime;
  final FocusNode? focusNodeAtual;
  final FocusNode? focusNodeProx;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onFieldSubmittedFunction;
  final Color borderColor;

  const TextFormFieldComponent({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validar = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isTime = false,
    this.focusNodeAtual,
    this.focusNodeProx,
    this.inputFormatters,
    this.onFieldSubmittedFunction,
    this.textInputAction = TextInputAction.next,
    this.borderColor = colorPrimary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (_value) {
          if (validar) {
            final valueString = _value ?? '';
            if (valueString.trim().isEmpty) {
              return 'O campo deve ser informado';
            }
            if (isTime) {
              List<String> partes = valueString.split(':');
              int hora = int.parse(partes[0]);
              int minuto = int.parse(partes[1]);
              if (hora == 0 && minuto == 0) {
                return 'O campo deve ser informado';
              }
            }
          }
          return null;
        },
        inputFormatters: inputFormatters,
        autofocus: autofocus,
        readOnly: readOnly,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNodeAtual,
        onFieldSubmitted: (_) {
          onFieldSubmittedFunction == null ? _onFieldSubmittedFunctionPadrao : onFieldSubmittedFunction!();
        },
        decoration: InputDecoratorComponent(
          borderColor: borderColor,
          enabledBorder: borderColor,
          focusedBorder: borderColor,
          suffixIcon: suffixIcon,
          label: label,
        ).decorator(context));
  }

  void Function() _onFieldSubmittedFunctionPadrao(BuildContext context) {
    return () => FocusScope.of(context).requestFocus(focusNodeProx);
  }
}
