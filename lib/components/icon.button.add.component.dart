import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IconButtonAddComponent extends StatelessWidget {
  final void Function() onPressed;

  const IconButtonAddComponent({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () => onPressed(),
    );
  }
}
