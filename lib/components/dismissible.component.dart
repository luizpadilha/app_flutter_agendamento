import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/alert.component.dart';

class DismissibleComponent extends StatelessWidget {
  final Key keyDism;
  final Widget child;
  final Object object;
  final String idRemover;
  final Future<void> Function() futureRemover;
  final BuildContext contextPai;

  const DismissibleComponent({
    required this.keyDism,
    required this.child,
    required this.object,
    required this.idRemover,
    required this.futureRemover,
    required this.contextPai,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: keyDism,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 5),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog<bool>(
          context: context,
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
      },
      onDismissed: (direction) async {
        await _remover();
      },
      child: child,
    );
  }
  
  Future<void> _remover() async {
    try {
      await futureRemover();
      AlertComponent.show(contextPai,
          title: "Removido com Sucesso!",
          subTitle: "O item: ${object.toString()} foi removida com Sucesso",
          style: AlertStyle.success);
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
