import 'package:flutter/material.dart';
import 'package:mybabernew/constants.dart';

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
  final int proporcaoLabel;

  InputDecoratorComponent(
      {required this.label,
      this.suffixIcon,
      this.textColor = Colors.black,
      this.borderColor = colorPrimary,
      this.enabledBorder = colorPrimary,
      this.errorBorder = Colors.red,
      this.focusedBorder = colorPrimary,
      this.fillColor = Colors.white,
      this.prefixIcon,
      this.errorText,
      this.proporcaoLabel = 2,
      this.hintText});

  InputDecoration decorator(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0)),
      labelText: label,
      labelStyle: getTextStyle(context, proporcaoLabel),
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

   TextStyle? getTextStyle(BuildContext context, int sizeCode) {
     var textTheme = Theme.of(context).textTheme;
    switch (sizeCode) {
      case 1:
        return textTheme.bodySmall;
      case 2:
        return textTheme.bodyMedium;
      case 3:
        return textTheme.bodyLarge;
      default:
        return textTheme.bodyMedium;
    }
  }
}
