import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AutoCompleteComponent extends StatefulWidget {
  final Function(Object) onSelected;
  final bool validate;
  final AutocompleteOptionsBuilder<Object> optionsBuilder;
  final String hintText;
  final String label;
  final String? term;

  AutoCompleteComponent({
    required this.onSelected,
    required this.validate,
    required this.optionsBuilder,
    required this.hintText,
    required this.label,
    required this.term,
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
          displayStringForOption: _displayStringForOption,
          optionsBuilder: widget.optionsBuilder,
          onSelected: widget.onSelected,
          fieldViewBuilder:
              (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: mediaQuery.textScaler.scale(14)),
              onEditingComplete: onEditingComplete,
              decoration: InputDecoratorComponent (
                label: widget.label,
                hintText: widget.hintText,
                errorText:
                widget.validate ? "O campo deve ser informado" : null,
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
                  constraints:
                  BoxConstraints(maxHeight: (deviceSize.height * 0.50),
                      maxWidth: deviceSize.width * 0.90),
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
                            highlight ? Theme
                                .of(context)
                                .focusColor : null,
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
