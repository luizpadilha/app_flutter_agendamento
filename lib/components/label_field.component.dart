import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LabelAndFieldComponent extends StatelessWidget {
  final String label;
  final String field;
  final bool inline;

  const LabelAndFieldComponent(
      {Key? key, required this.label, required this.field, this.inline = false})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var labelWidget = Text(
      "${label.toUpperCase()}:",
      style: const TextStyle(fontSize: 12),
    );
    var fieldWidget = Flexible(
      fit: FlexFit.loose,
      child: AutoSizeText(
        field,
        maxLines: 2,
        overflowReplacement: const Text("..."),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );

    return inline
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelWidget,
              const SizedBox(
                width: 5,
              ),
              fieldWidget
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelWidget, fieldWidget],
          );
  }
}
