import 'package:flutter/material.dart';
import 'package:mybabernew/components/elevated.button.component.dart';

class AlertDialogComponent extends StatelessWidget {

  final Widget content;

  const AlertDialogComponent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      titleTextStyle: textTheme.labelLarge,
      title: Text('Tem certeza?', style: textTheme.bodyLarge?.copyWith(color: Colors.black)),
      content: content,
      actions: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _action(colorScheme.tertiary, context, 'Não', false),
            _action(colorScheme.secondary, context, 'Sim', true),
          ],
        ),
      ],
    );
  }

  Widget _action(Color color, BuildContext context, String label, bool result) {
    var mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return  Expanded(
      child: Padding(
        padding: EdgeInsets.all(deviceSize.width * 0.02),
        child: ElevatedButtonComponent(
          isRow: true,
          isBorderCircular: true,
          label: label,
          onPressed: () {
            Navigator.pop(context, result);
          },
          color: color,
        ),
      ),
    );
  }
}
