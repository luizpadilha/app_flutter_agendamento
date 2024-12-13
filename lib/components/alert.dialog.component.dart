import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/text_button.component.dart';

class AlertDialogComponent extends StatelessWidget {

  final Widget content;

  const AlertDialogComponent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      titleTextStyle: textTheme.labelLarge,
      title: Text('Tem certeza?', style: textTheme.bodyLarge?.copyWith(color: Colors.black)),
      content: content,
      actions: <Widget>[
        TextButtonComponent(
          colorFonte: Colors.black,
          colorBorda: Colors.black,
          label: 'Não',
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButtonComponent(
          colorFonte: Colors.black,
          colorBorda: Colors.black,
          label: 'Sim',
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
