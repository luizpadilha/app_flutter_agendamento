import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/input_decorator.dart';

class DropDownComponent extends StatefulWidget {
  final Function(Object?) onChanged;
  final List<Object> items;
  final String label;
  final Object? value;
  final double? menuMaxHeight;
  final bool validate;

  const DropDownComponent({
    super.key,
    required this.onChanged,
    required this.items,
    required this.label,
    required this.value,
    this.menuMaxHeight,
    this.validate = false,
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
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<Object>(
        isExpanded: true,
        menuMaxHeight: widget.menuMaxHeight,
        value: widget.value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: widget.onChanged,
        alignment: AlignmentDirectional.centerEnd,
        items: widget.items.map((Object option) {
          return DropdownMenuItem<Object>(
            value: option,
            child: SizedBox(
              width: deviceSize.width * 0.50,
              child: Text(
                option.toString(),
                style: textTheme.bodyMedium,
              ),
            ),
          );
        }).toList(),
        decoration: InputDecoratorComponent(
          errorText: widget.validate ? "O campo deve ser informado" : null,
          label: widget.label,
        ).decorator(),
      ),
    );
  }
}
