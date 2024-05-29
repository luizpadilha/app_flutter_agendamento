import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ? Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _autoSizeText(context),
          ],
        ),
      ),
    ) : Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty-list.png',
              width:
              MediaQuery.of(context).size.width / 3,
              // color: Colors.black87,
            ),
            const SizedBox(
              height: 20,
            ),
            _autoSizeText(context),
          ],
        ),
      ),
    );
  }


  Widget _autoSizeText(BuildContext context) {
    return AutoSizeText(
      "Não foram encontrados registros vinculado ao seu usuário",
      maxLines: 5,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
