import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/input_decorator.dart';

class DropDownComponent extends StatefulWidget {
  final Function(Object?) onChanged;
  final List<DropdownMenuItem<Object>> items;
  final String label;
  final Object? value;
  final double? menuMaxHeight;

  const DropDownComponent({
    super.key,
    required this.onChanged,
    required this.items,
    required this.label,
    required this.value,
    this.menuMaxHeight,
  });

  @override
  State<DropDownComponent> createState() => _DropDownComponentState();
}

class _DropDownComponentState extends State<DropDownComponent> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Object>(
      isExpanded: true,
      menuMaxHeight: widget.menuMaxHeight,
      value: widget.value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      onChanged: widget.onChanged,
      items: widget.items,
      decoration: InputDecoratorComponent(
        label: widget.label,
      ).decorator(),
    );
  }
}
