import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/card.component.dart';

class ListTileComponent extends StatelessWidget {
  final IconData? icon;
  final String? titulo;
  final String? subTitulo;
  final List<Widget>? children;
  final void Function() function;
  final double height;
  final Color? color;

  const ListTileComponent({
    super.key,
    this.icon,
    this.titulo,
    this.subTitulo,
    required this.function,
    this.children,
    this.color,
    this.height = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;
    var heightDisp = deviceSize.height - mediaQuery.padding.top;
    var textTheme = Theme.of(context).textTheme;
    return CardComponent(
        padding: 0,
        color: color,
        child: InkWell(
            onTap: () => function(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: heightDisp * height,
                child: Row(
                  children: <Widget>[
                    if (icon != null)
                      Container(
                        height: heightDisp * height,
                        width: heightDisp * height,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Icon(icon,
                            color: Colors.white, size: heightDisp * 0.06),
                      ),
                    SizedBox(width: deviceSize.width * 0.02),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children ??
                            <Widget>[
                              Flexible(
                                child: AutoSizeText(
                                  titulo ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              Flexible(
                                child: AutoSizeText(
                                  subTitulo ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: textTheme.bodySmall!
                                      .copyWith(color: Colors.black54),
                                ),
                              ),
                            ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
