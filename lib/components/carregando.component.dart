import 'package:flutter/material.dart';
import 'package:mybabernew/constants.dart';

class Carregando extends StatelessWidget {
  final double tamanho;
  final bool inverterCor;
  final bool mostrarTexto;

  const Carregando({
    Key? key,
    this.tamanho = 35,
    this.inverterCor = false,
    this.mostrarTexto = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: tamanho,
          width: tamanho,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: platformIsIos(context)
                ? (inverterCor ? Colors.blueAccent : Colors.white)
                : null,
            valueColor: !platformIsIos(context)
                ? AlwaysStoppedAnimation<Color>(
                    inverterCor ? Colors.blueAccent : Colors.white)
                : null,
          ),
        ),
        if (mostrarTexto)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Carregando...',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}
