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
  final bool itemVazio;
  final FocusNode? focusNode;

  const DropDownComponent({
    super.key,
    required this.onChanged,
    required this.items,
    required this.label,
    required this.value,
    this.menuMaxHeight,
    this.validate = false,
    this.itemVazio = false,
    this.focusNode,
  });

  @override
  State<DropDownComponent> createState() => _DropDownComponentState();
}

class _DropDownComponentState extends State<DropDownComponent> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<Object>(
        focusNode: widget.focusNode,
        isExpanded: true,
        menuMaxHeight: widget.menuMaxHeight,
        value: widget.value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onChanged: widget.onChanged,
        alignment: AlignmentDirectional.centerEnd,
        items: itensDrop(context),
        decoration: InputDecoratorComponent(
          errorText: widget.validate ? "O campo deve ser informado" : null,
          label: widget.label,
        ).decorator(),
      ),
    );
  }

  List<DropdownMenuItem<Object>> itensDrop(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    List<DropdownMenuItem<Object>> retorno = [];
    if (widget.itemVazio) {
      retorno.add(DropdownMenuItem<Object>(
        value: null,
        child: SizedBox(
          width: deviceSize.width * 0.50,
          child: Text(
            'Nenhum',
            style: textTheme.bodyMedium,
          ),
        ),
      ));
    }
    retorno.addAll(widget.items.map((Object option) {
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
    }).toList());
    return retorno;
  }
}
