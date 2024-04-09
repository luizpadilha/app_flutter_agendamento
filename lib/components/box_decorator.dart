import 'package:flutter/material.dart';

class BoxDecorator {
  Color fillColor;

  BoxDecorator({
    this.fillColor = Colors.white,
  });

  BoxDecoration boxDecorator() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.blue, // Cor da borda
        width: 0.0, // Largura da borda
      ),
      borderRadius: BorderRadius.circular(10), // Borda circular
      color: fillColor, // Cor de fundo
      boxShadow: [
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
