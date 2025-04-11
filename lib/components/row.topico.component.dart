import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RowTopicoComponent extends StatelessWidget {

  final String label;

  const RowTopicoComponent({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: textTheme.bodyMedium),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
