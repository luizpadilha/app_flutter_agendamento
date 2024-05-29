import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mybabernew/components/alert.component.dart';

class SlidableComponent extends StatelessWidget {
  final Widget child;
  final Key keySlid;
  final Object object;
  final Future<void> Function()? futureRemover;
  final void Function()? functionEditar;
  final BuildContext contextPai;
  final List<Widget>? actions;

  const SlidableComponent({
    required this.child,
    required this.keySlid,
    required this.contextPai,
    this.futureRemover,
    this.functionEditar,
    required this.object,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: child,
      key: keySlid,
      startActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const DrawerMotion(),
        children: _children(),
      ),
    );
  }

  List<Widget> _children() {
    List<Widget> children = [];
    if (actions != null && actions!.isNotEmpty) {
      children.addAll(actions!);
    }
    if (functionEditar != null) {
      children.add(
        SlidableAction(
          onPressed: (context) => functionEditar!(),
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Editar',
        ),
      );
    }
    if (futureRemover != null) {
      children.add(
        SlidableAction(
          onPressed: (context) async {
            await _remover();
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Remover',
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
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Sim'),
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
      if (error is DioException) {
        AlertComponent.show(contextPai,
            title: "Ops!",
            subTitle: error.response!.data,
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
