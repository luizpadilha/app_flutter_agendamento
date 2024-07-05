import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: deviceSize.height / 3,
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
                              child: AutoSizeText(
                                  title,
                                  maxLines: 2,
                                  style: textTheme.displayLarge),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: AutoSizeText(
                                    subTitle,
                                    maxLines: 5,
                                    minFontSize: mediaQuery.textScaler.scale(10),
                                    maxFontSize: mediaQuery.textScaler.scale(14),
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.displayMedium),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                      TextButton(
                          child: Text(textConfirm ?? 'Continuar',
                              style: textTheme.displayLarge),
                          onPressed: () async {
                            if (onConfirm != null) {
                              await onConfirm();
                            } else {
                              Navigator.pop(context);
                            }
                          })
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
      return Colors.redAccent;
    case AlertStyle.success:
      return Colors.green;
    case AlertStyle.confirm:
      return Colors.blue;
    case AlertStyle.warning:
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}


enum AlertStyle { success, error, confirm, warning }
