import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LabelAndFieldComponent extends StatelessWidget {
  final String label;
  final String field;
  final bool inline;
  final bool subtitle;
  final int maxLinesField;
  final double? widthLabel;
  final double height;


  LabelAndFieldComponent({
    this.subtitle = false,
    this.widthLabel,
    required this.label,
    required this.field,
    this.inline = false,
    this.maxLinesField = 2,
    this.height = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;
    var heightDisp = deviceSize.height - mediaQuery.padding.top;
    var textTheme = Theme.of(context).textTheme;
    var labelWidget = SizedBox(
      width: widthLabel,
      child: AutoSizeText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        "${label}:",
        style: subtitle ? textTheme.bodySmall!.copyWith(color: Colors.black54) : textTheme.bodyMedium,
      ),
    );
    var fieldWidget = Flexible(
      child: AutoSizeText(
        field,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLinesField,
        style: subtitle ? textTheme.bodySmall!.copyWith(color: Colors.black54) : textTheme.bodyMedium,
      ),
    );

    return inline
        ? SizedBox(
          height: heightDisp * height,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                const SizedBox(width: 5),
                fieldWidget
              ],
            ),
        )
        : SizedBox(
          height: heightDisp * height,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [labelWidget, fieldWidget],
            ),
        );
  }
}
