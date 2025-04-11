import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/components/card.component.dart';

class CardTituloComponent extends StatefulWidget {
  final Widget child;
  final String titulo;
  final bool isSubTitulo;
  final bool isExpanded;
  final Function(bool) onPressed;

  const CardTituloComponent({
    super.key,
    required this.child,
    required this.titulo,
    this.isSubTitulo = false,
    this.isExpanded = false,
    required this.onPressed,
  });

  @override
  _CardTituloComponentState createState() => _CardTituloComponentState();
}

class _CardTituloComponentState extends State<CardTituloComponent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    if (_isExpanded) {
      _controller.forward();
    }
  }

  void _toggleExpand() {
    _isExpanded = !_isExpanded;
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onPressed(_isExpanded);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return CardComponent(
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpand,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(deviceSize.height * 0.015),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.titulo,
                      style: (widget.isSubTitulo ? textTheme.titleSmall : textTheme.titleMedium)?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(seconds: 1),
                    child: const Icon(Icons.expand_more, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Container(
              padding: EdgeInsets.all(deviceSize.height * 0.015),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
