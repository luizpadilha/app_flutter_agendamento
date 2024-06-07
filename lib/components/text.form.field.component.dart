import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/input_decorator.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool validar;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNodeAtual;
  final FocusNode? focusNodeProx;
  final TextInputAction textInputAction;

  const TextFormFieldComponent({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validar = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNodeAtual,
    this.focusNodeProx,
    this.textInputAction = TextInputAction.next,
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
          }
          return null;
        },
        autofocus: autofocus,
        readOnly: readOnly,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNodeAtual,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focusNodeProx);
        },
        decoration: InputDecoratorComponent(
          suffixIcon: suffixIcon,
          label: label,
        ).decorator());
  }
}
