import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/icon.button.component.dart';
import 'package:mybabernew/modules/home/home.module.dart';

class ScaffoldComponent extends StatelessWidget {
  final String titleAppBar;
  final Widget? widgetTitleAppBar;
  final bool isHome;
  final bool isDrawer;
  final bool extendBody;
  final bool isActionHome;
  final bool isActionVoltar;
  final bool isAppBar;
  final Widget body;
  List<Widget>? actions;
  final void Function()? onPressedFloatingActionButton;
  final void Function()? onTapGestureDetector;

  ScaffoldComponent({
    required this.titleAppBar,
    this.widgetTitleAppBar,
    required this.body,
    this.isHome = false,
    this.isDrawer = false,
    this.isAppBar = true,
    this.isActionHome = false,
    this.extendBody = false,
    this.isActionVoltar = false,
    this.actions,
    this.onPressedFloatingActionButton,
    this.onTapGestureDetector,
    super.key,
  });

  void _onTapGestureDetectorPadrao(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var deviceSize = mediaQuery.size;
    final textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (onTapGestureDetector == null) {
          _onTapGestureDetectorPadrao(context);
        } else {
          onTapGestureDetector!();
        }
      },
      child: Scaffold(
        appBar: !isAppBar ? null : AppBar(
          toolbarHeight: deviceSize.height * 0.08,
          title: widgetTitleAppBar ?? Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              style: textTheme.titleMedium,
              titleAppBar,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          actions: _actions(deviceSize),
          leading: _leading(deviceSize),
        ),
        drawer: isDrawer ? const AppDrawerComponent() : null,
        extendBody: extendBody,
        body: Stack(
          children: [
            if (isHome)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary, // Tom mais claro
                      const Color(0xFF85D7CB),
                      const Color(0xFFC2F0F2),
                      const Color(0xFFEAFBFC),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            body,
          ],
        ),
        backgroundColor: !isHome ? const Color(0xFFEAF6F6) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  List<Widget> _actions(var deviceSize) {
    List<Widget> actions = [];
    if (this.actions != null) {
      actions.addAll(this.actions!);
    }
    return actions;
  }

  Widget? _leading(var deviceSize) {
    if (isActionHome) {
      return _actionHome(deviceSize);
    }
    if (isActionVoltar) {
      return _actionVoltar(deviceSize);
    }
    if (isDrawer) {
      return _actionDrawer(deviceSize);
    }
    return null;
  }



  Widget _actionHome(var deviceSize) {
    return IconButtonComponent(
      iconColor: Colors.white,
      icon: Icons.home,
      onPressed: () {
        Modular.to.pushReplacementNamed(HomeModule.ROUTE, arguments: null);
      },
    );
  }

  Widget _actionVoltar(Size deviceSize) {
    return IconButtonComponent(
      iconColor: Colors.white,
      icon: Icons.arrow_back,
      onPressed: () {
        Modular.to.pop();
      },
    );
  }

  Widget _actionDrawer(var deviceSize) {
    return Builder(builder: (context) {
      return IconButtonComponent(
        iconColor: Colors.white,
        icon: Icons.menu,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    });
  }
}
