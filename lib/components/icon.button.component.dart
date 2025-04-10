import 'package:flutter/material.dart';

class IconButtonComponent extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? colorBorder;

  const IconButtonComponent({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.colorBorder,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return IconButton(
      style: backgroundColor == null
          ? null
          : ElevatedButton.styleFrom(
              minimumSize: Size(deviceSize.width * 0.08, deviceSize.width * 0.08),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10),
                ),
              ),
              side: BorderSide(color: (colorBorder ?? Colors.black12), width: 1.5),
              textStyle: textTheme.labelSmall,
              backgroundColor: backgroundColor,
            ),
      icon: Icon(
        icon,
        size: deviceSize.height * 0.04,
        color: iconColor ?? Colors.black,
      ),
      onPressed: onPressed,
    );
  }
}
