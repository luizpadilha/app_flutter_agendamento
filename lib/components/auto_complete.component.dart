import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AutoCompleteComponent extends StatefulWidget {
  final Function(Object) onSelected;
  final AutocompleteOptionsBuilder<Object> optionsBuilder;
  final String? term;
  final String? initialValue;
  Widget Function(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted,
      ) fieldViewBuilder;

  AutoCompleteComponent({
    required this.onSelected,
    required this.optionsBuilder,
    required this.term,
    required this.initialValue,
    required this.fieldViewBuilder,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete(
          initialValue: TextEditingValue(text: widget.initialValue ?? ''),
          displayStringForOption: _displayStringForOption,
          optionsBuilder: widget.optionsBuilder,
          onSelected: widget.onSelected,
          fieldViewBuilder: widget.fieldViewBuilder,
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


