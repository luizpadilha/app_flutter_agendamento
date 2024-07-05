import 'package:flutter/material.dart';
import 'package:mybabernew/constants.dart';

class BoxDecoratorComponent {
  Color fillColor;
  bool sombra;

  BoxDecoratorComponent({
    this.fillColor = Colors.white,
    this.sombra = false,
  });

  BoxDecoration boxDecorator() {
    return BoxDecoration(
      border: Border.all(
        color: colorPrimary, // Cor da borda
        width: 0.0, // Largura da borda
      ),
      borderRadius: BorderRadius.circular(10), // Borda circular
      color: fillColor, // Cor de fundo
      boxShadow: !sombra ? null : [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Cor da sombra
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2), // Deslocamento da sombra
        ),
      ],
    );
  }
}
