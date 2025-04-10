import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final double iconSize;
  final String label;
  final Color color;
  final Color? colorLabel;
  final bool isRow;
  final bool isBorderCircular;
  final TextStyle? textStyle;

  const ElevatedButtonComponent({
    this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isRow = false,
    this.isBorderCircular = false,
    this.textStyle,
    this.colorLabel,
    this.iconSize = 0.05,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var deviceSize = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(deviceSize.width * 0.08, deviceSize.height * 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(isBorderCircular ? 10 : 0),
          ),
        ),
        textStyle: textTheme.labelSmall,
        backgroundColor: color,
      ),
      child: isRow
          ? Row(
              mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: AutoSizeText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    label,
                    style: (textStyle ?? textTheme.labelLarge)!.copyWith(color: colorLabel ?? Colors.white),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: Colors.white, size: deviceSize.width * iconSize),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: AutoSizeText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    label,
                    style: (textStyle ?? textTheme.labelLarge)!.copyWith(color: colorLabel ?? Colors.white),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: Colors.white, size: deviceSize.width * iconSize),
              ],
            ),
    );
  }
}
