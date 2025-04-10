import 'package:auto_size_text/auto_size_text.dart';
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
  final bool readOnly;
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
    this.readOnly = false,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownButtonFormField<Object>(
            focusNode: widget.focusNode,
            isExpanded: true,
            menuMaxHeight: widget.menuMaxHeight,
            value: widget.value,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onChanged: widget.onChanged,
            alignment: AlignmentDirectional.centerEnd,
            items: widget.readOnly ? itensDropVizualizar(context, constraints) : itensDrop(context, constraints),
            decoration: InputDecoratorComponent(
              errorText: widget.validate ? "O campo deve ser informado" : null,
              label: widget.label,
            ).decorator(context),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<Object>> itensDrop(
      BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    List<DropdownMenuItem<Object>> retorno = [];
    if (widget.itemVazio) {
      retorno.add(
        DropdownMenuItem<Object>(
          value: null,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: (deviceSize.height * 0.25),
                maxWidth: constraints.maxWidth),
            child: Text(
              'Nenhum',
              style: textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }
    retorno.addAll(widget.items.map((Object option) {
      return DropdownMenuItem<Object>(
        value: option,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: (deviceSize.height * 0.25),
              maxWidth: constraints.maxWidth),
          child: AutoSizeText(
            option.toString(),
            style: textTheme.bodyMedium,
          ),
        ),
      );
    }).toList());
    return retorno;
  }

  List<DropdownMenuItem<Object>> itensDropVizualizar(
      BuildContext context, BoxConstraints constraints) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    List<DropdownMenuItem<Object>> retorno = [];
    retorno.add(
      DropdownMenuItem<Object>(
        value: widget.value,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: (deviceSize.height * 0.25),
              maxWidth: constraints.maxWidth),
          child: AutoSizeText(
            widget.value == null ? 'Nenhum' : widget.value.toString(),
            style: textTheme.bodyMedium,
          ),
        ),
      ),
    );
    return retorno;
  }
}
