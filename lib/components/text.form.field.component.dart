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

  const TextFormFieldComponent({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validar = true,
    this.readOnly = false,
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
        readOnly: readOnly,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoratorComponent(
          suffixIcon: suffixIcon,
          label: label,
        ).decorator());
  }
}
