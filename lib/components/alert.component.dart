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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              decoration: BoxDecoration(
                  color: style == AlertStyle.error
                      ? Colors.redAccent
                      : Colors.green,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(5.0, 20, 5, 10),
                        child: Center(
                          child: AutoSizeText("$title",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: AutoSizeText("$subTitle",
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontSize: 15, color: Colors.white)),
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
                            child: Text('${textDismiss}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () async {
                              if (onDismiss != null) {
                                await onDismiss();
                              } else {
                                Navigator.pop(context);
                              }
                            }),
                      ),
                      TextButton(
                          child: Text(
                              '${textConfirm != null ? textConfirm : 'Continuar'}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
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

enum AlertStyle { success, error, confirm, loading }
