import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final double? elevation;
  final double padding;

  const CardComponent({
    super.key,
    this.color = Colors.white,
    this.margin,
    this.elevation = 3,
    this.padding = 0.02,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: elevation,
      color: color,
      margin: margin ?? const EdgeInsets.only(top: 5),
      child: Padding(
          padding: EdgeInsets.all(deviceSize.width * padding),
          child: child
      ),
    );
  }
}
