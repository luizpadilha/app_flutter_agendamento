import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends StatelessWidget {
  String label;
  IconData? icon;
  Function() onPressed;
  bool withBorda;
  Color? colorFonte;
  Color? colorBorda;

  TextButtonComponent({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.withBorda = true,
    this.colorFonte,
    this.colorBorda,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return TextButton(
      style: TextButton.styleFrom(
        side: withBorda
            ? BorderSide(color: (colorBorda ?? Colors.white), width: 1.5)
            : null, // Define a borda
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Deixa a borda arredondada
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 20), // Ajusta o padding interno
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        label,
        style: colorFonte == null
            ? Theme.of(context).textTheme.displayMedium
            : Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(color: colorFonte),
        textAlign: TextAlign.left,
      ),
    );
  }
}
