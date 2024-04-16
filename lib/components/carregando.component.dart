import 'package:flutter/cupertino.dart';
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
    this.mostrarTexto = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: tamanho,
            width: tamanho,
            child: platformIsIos(context)
                ? CupertinoActivityIndicator(color: (inverterCor ? Colors.blueAccent : Colors.white))
                : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(inverterCor ? Colors.blueAccent : Colors.white))
        ),
        if (mostrarTexto)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Carregando...',
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}
