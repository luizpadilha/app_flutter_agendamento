import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final bool isRow;
  final bool isBorderCircular;
  final TextStyle? textStyle;

  const ElevatedButtonComponent({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isRow = false,
    this.isBorderCircular = false,
    this.textStyle,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Expanded(child: Text(label, style: textStyle ?? textTheme.labelLarge)),
          Center(child: Icon(icon, color: Colors.black54)),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: AutoSizeText(
              label,
              style: textStyle ?? textTheme.labelLarge,
            ),
          ),
          Expanded(child: Center(child: Icon(icon, color: Colors.black54))),
        ],
      ),
    );
  }
}
