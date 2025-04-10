import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridTileComponent extends StatelessWidget {
  final IconData icon;
  final String nome;
  final void Function() onTap;

  const GridTileComponent(
      {required this.icon, required this.nome, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GridTile(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 60,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: FittedBox(
                    child: Icon(
                      icon,
                      size: deviceSize.width * 0.18,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: deviceSize.height * 0.01),
            AutoSizeText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              nome,
              style: textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
