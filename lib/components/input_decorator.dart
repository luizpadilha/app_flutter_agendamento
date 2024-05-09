import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputDecoratorComponent {
  final String label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color textColor;
  final Color borderColor;
  Color fillColor;
  Color enabledBorder;
  Color focusedBorder;
  Color errorBorder;
  final String? errorText;
  final String? hintText;

  InputDecoratorComponent(
      {required this.label,
      this.suffixIcon,
      this.textColor = Colors.black,
      this.borderColor = Colors.blueAccent,
      this.enabledBorder = Colors.blue,
      this.errorBorder = Colors.red,
      this.focusedBorder = Colors.lightBlue,
      this.fillColor = Colors.white,
      this.prefixIcon,
      this.errorText,
      this.hintText});

  InputDecoration decorator() {
    return InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.0)),
      labelText: label,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorBorder, width: 0.0),
      ),
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: enabledBorder,
          width: 0,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: focusedBorder,
          width: 0.5,
          style: BorderStyle.solid,
        ),
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
    );
  }
}
