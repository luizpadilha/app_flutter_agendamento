import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/elevated.button.component.dart';
import 'package:mybabernew/exceptions/my.exception.dart';

class SlidableComponent extends StatelessWidget {
  final Widget child;
  final Key keySlid;
  final Object object;
  final Future<void> Function()? futureRemover;
  final void Function()? functionEditar;
  final BuildContext contextPai;
  final List<Widget>? actions;
  final bool enabled;

  const SlidableComponent({
    required this.child,
    required this.keySlid,
    required this.contextPai,
    this.futureRemover,
    this.functionEditar,
    required this.object,
    this.actions,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enabled,
      child: child,
      key: keySlid,
      startActionPane: ActionPane(
        extentRatio: 0.7,
        motion: const DrawerMotion(),
        children: _children(context),
      ),
    );
  }

  List<Widget> _children(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    List<Widget> children = [];
    if (actions != null && actions!.isNotEmpty) {
      children.addAll(actions!);
    }
    if (functionEditar != null) {
      children.add(
        Expanded(
          child: ElevatedButtonComponent(
            textStyle: textTheme.labelSmall,
            isRow: false,
            onPressed: () => functionEditar!(),
            icon: Icons.edit,
            label: 'Editar',
            color: Colors.black12,
          ),
        ),
      );
    }
    if (futureRemover != null) {
      children.add(
        Expanded(
          child: ElevatedButtonComponent(
            textStyle: textTheme.labelSmall,
            isRow: false,
            onPressed: () async {
              await _remover();
            },
            icon: Icons.delete,
            label: 'Remover',
            color: Colors.redAccent,
          ),
        ),
      );
    }
    return children;
  }

  Future<void> _remover() async {
    var textTheme = Theme.of(contextPai).textTheme;
    try {
      bool? remover = await showDialog<bool>(
        context: contextPai,
        builder: (ctx) => AlertDialog(
          title: const Text('Tem Certeza?'),
          titleTextStyle: textTheme.bodyLarge,
          content: const Text('Quer remover o item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Não', style: textTheme.bodyLarge),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Sim', style: textTheme.bodyLarge),
            ),
          ],
        ),
      );
      if (remover ?? false) {
        await futureRemover!();
        AlertComponent.show(contextPai,
            title: "Removido com Sucesso!",
            subTitle: "O item: ${object.toString()} foi removida com Sucesso",
            style: AlertStyle.success);
      }
    } catch (error) {
      if (error is MyException) {
        AlertComponent.show(contextPai,
            title: "Ops!",
            subTitle: error.msg,
            style: AlertStyle.error);
      } else {
        AlertComponent.show(contextPai,
            title: "Ops!",
            subTitle: "Erro ao remover",
            style: AlertStyle.error);
      }
    }
  }
}
