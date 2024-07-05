import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AutoCompleteComponent extends StatefulWidget {
  final Function(Object) onSelected;
  final AutocompleteOptionsBuilder<Object> optionsBuilder;
  final String? term;
  final String label;
  final bool validate;
  final bool readOnly;
  FocusNode focusNode;
  TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final void Function()? onTapTextForm;

  AutoCompleteComponent({
    required this.onSelected,
    required this.optionsBuilder,
    required this.term,
    required this.label,
    required this.focusNode,
    required this.textEditingController,
    this.validate = false,
    this.readOnly = false,
    this.textInputAction = TextInputAction.next,
    this.onTapTextForm,
  });

  @override
  State<AutoCompleteComponent> createState() => _AutoCompleteComponentState();
}

class _AutoCompleteComponentState extends State<AutoCompleteComponent> {
  static String _displayStringForOption(Object option) {
    return option.toString();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    var textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete(
          focusNode: widget.focusNode,
          textEditingController: widget.textEditingController,
          displayStringForOption: _displayStringForOption,
          optionsBuilder: widget.optionsBuilder,
          onSelected: widget.onSelected,
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextFormField(
              readOnly: widget.readOnly,
              textInputAction: widget.textInputAction,
              controller: controller,
              focusNode: focusNode,
              onTap: () {
                widget.onTapTextForm == null ? null : widget.onTapTextForm!();
              },
              style: textTheme.bodyMedium,
              onEditingComplete: onEditingComplete,
              decoration: InputDecoratorComponent(
                label: widget.label,
                errorText: widget.validate ? "O campo deve ser informado" : null,
                hintText: 'Digite para pesquisar...',
                prefixIcon: const Icon(Icons.search),
              ).decorator(),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: (deviceSize.height * 0.25),
                      maxWidth: constraints.maxWidth),
                  //RELEVANT CHANGE: added maxWidth
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Builder(builder: (BuildContext context) {
                          final bool highlight =
                              AutocompleteHighlightedOption.of(context) ==
                                  index;
                          if (highlight) {
                            SchedulerBinding.instance
                                .addPostFrameCallback((Duration timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            });
                          }
                          return Container(
                            color:
                            highlight ? Theme.of(context).focusColor : null,
                            padding: const EdgeInsets.all(16.0),
                            child: SubstringHighlight(
                              text: option.toString(),
                              textStyleHighlight:
                              const TextStyle(color: Colors.purple),
                              term: widget.term,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


