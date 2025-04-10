import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String? label;
  const EmptyList({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final deviceSize = MediaQuery.of(context).size;
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
    ) : Padding(
      padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.10, 0, 0),
      child: Column(
        children: [
          SizedBox(
            width: deviceSize.width,
            height: deviceSize.height * 0.40,
            child: Image.asset(
              fit: BoxFit.fitWidth,
              'assets/images/empty-list.png',
              // color: Colors.black87,
            ),
          ),
          _autoSizeText(context),
        ],
      ),
    );
  }


  Widget _autoSizeText(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AutoSizeText(
      label ?? "Nenhum registro foi encontrado.",
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: textTheme.titleLarge!.copyWith(color: colorScheme.primary),
    );
  }
}
