import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonComponent extends StatelessWidget {
  final void Function() onPressed;

  const FloatingActionButtonComponent({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      foregroundColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      onPressed: () => onPressed(),
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
