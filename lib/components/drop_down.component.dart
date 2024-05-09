import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/input_decorator.dart';


class DropDownComponent extends StatefulWidget {
  final Function(Object?) onChanged;
  final List<Object> items;
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
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownButtonFormField<Object>(
        isExpanded: true,
        menuMaxHeight: widget.menuMaxHeight,
        value: widget.value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: widget.onChanged,
        items: widget.items.map((Object option) {
          return DropdownMenuItem<Object>(
            value: option,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: (deviceSize.height * 0.25),
                  maxWidth: constraints.maxWidth),
              child: Text(
                option.toString(),
                style: textTheme.bodyMedium,
              ),
            ),
          );
        }).toList(),
        decoration: InputDecoratorComponent(
          label: widget.label,
        ).decorator(),
      );
    });
  }
}
