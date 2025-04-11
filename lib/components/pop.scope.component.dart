import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybabernew/components/dialog.confirmar.component.dart';

class PopScopeComponent extends StatelessWidget {
  final Widget child;

  const PopScopeComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _dialogBack(context) ?? false;
        if (context.mounted && shouldPop) {
          SystemNavigator.pop();
        }
      }, child: child,
    );
  }

  Future<bool?> _dialogBack(BuildContext context) async {
    var textTheme = Theme.of(context).textTheme;
    return await ShowDialogConfirmarComponent.showDialogConfirmar(
      context,
      content: Text('Tem certeza de que deseja sair do app?',
          style: textTheme.bodyLarge),
    );
  }

}

