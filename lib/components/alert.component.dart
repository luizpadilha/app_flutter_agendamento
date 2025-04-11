import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/elevated.button.component.dart';

abstract class AlertComponent {
  static void show(BuildContext context,
      {required String title,
      String subTitle = "",
      AlertStyle style = AlertStyle.confirm,
      Function? onConfirm,
      Function? onDismiss,
      String textConfirm = "Continuar",
      String? textDismiss}) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: deviceSize.height * 0.35,
              padding: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.05,
                vertical: deviceSize.height * 0.03,
              ),
              decoration: BoxDecoration(
                  color: _alertColor(style),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(5.0, 20, 5, 10),
                        child: Center(
                          child: AutoSizeText(title,
                              maxLines: 2, style: textTheme.displayLarge),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: AutoSizeText(subTitle,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.displayMedium),
                          ),
                        ),
                      ),
                    ],
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: textDismiss != null && textConfirm.isNotEmpty,
                        child: TextButton(
                            child: Text('$textDismiss',
                                style: textTheme.displayLarge),
                            onPressed: () async {
                              if (onDismiss != null) {
                                await onDismiss();
                              } else {
                                Navigator.pop(context);
                              }
                            }),
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.10,
                        width: deviceSize.width * 0.40,
                        child: Padding(
                          padding: EdgeInsets.all(deviceSize.width * 0.02),
                          child: ElevatedButtonComponent(
                            textStyle: textTheme.labelMedium,
                            isRow: true,
                            isBorderCircular: true,
                            label: textConfirm ?? 'Continuar',
                            onPressed: () async {
                              if (onConfirm != null) {
                                await onConfirm();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
        });
  }
}

Color _alertColor(AlertStyle style) {
  switch (style) {
    case AlertStyle.error:
      return Colors.red.shade500;
    case AlertStyle.success:
      return Colors.green.shade500;
    case AlertStyle.confirm:
      return Colors.blue.shade500;
    case AlertStyle.warning:
      return Colors.yellow.shade500;
    default:
      return Colors.grey.shade500;
  }
}

enum AlertStyle { success, error, confirm, warning }
